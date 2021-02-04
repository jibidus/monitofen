# frozen_string_literal: true

require 'nokogumbo'
require 'csv'
require 'net/http'
require 'uri'
require 'set'

HEADER_FILE = 'titles.csv'

# column name in CSV => metric label
CSV_MAPPING = {
  'AT [°C]' => 'T extérieure',
  'KT Ist [°C]' => 'TC mes',
  'KT Soll [°C]' => 'TC Ret cons',
  'BR ' => 'Fonct brûleur Std/Imp',
  'Sperrzeit ' => 'Blocage',
  'PE1_BR1 ' => 'PE1_BR1',
  'HK1 VL Ist[°C]' => 'CF1 (Plancher chf) T Dep mes',
  'HK1 VL Soll[°C]' => 'CF1 (Plancher chf) T Dep cons',
  'HK1 RT Ist[°C]' => 'CF1 (Plancher chf) T Amb mes.',
  'HK1 RT Soll[°C]' => 'CF1 (Plancher chf) T Amb Cons',
  'HK1 Pumpe' => 'CF1 (Plancher chf) Pompe',
  'HK1 Mischer' => 'CF1 (Plancher chf) VanMel',
  'HK1 Status' => 'CF1 (Plancher chf) Etat',
  'HK2 VL Ist[°C]' => 'CF2 (Radiateur) T Dep mes',
  'HK2 VL Soll[°C]' => 'CF2 (Radiateur) T Dep cons',
  'HK2 RT Ist[°C]' => 'CF2 (Radiateur) T Amb mes.',
  'HK2 RT Soll[°C]' => 'CF2 (Radiateur) T Amb Cons',
  'HK2 Pumpe' => 'CF2 (Radiateur) Pompe',
  'HK2 Mischer' => 'CF2 (Radiateur) VanMel',
  'HK2 Status' => 'CF2 (Radiateur) Etat',
  'Zubrp1 Pumpe' => 'Pompe primaire1 Pompe',
  'PE1 KT[°C]' => 'PE1 TC mes',
  'PE1 KT_SOLL[°C]' => 'PE1 TC Ret cons',
  'PE1 UW Freigabe[°C]' => 'PE1 T démarrage pompe',
  'PE1 Modulation[%]' => 'PE1 Niveau de Modulation',
  'PE1 FRT Ist[°C]' => 'PE1 T Flam mes.',
  'PE1 FRT Soll[°C]' => 'PE1 T Flam cons.',
  'PE1 FRT End[°C]' => 'PE1 FRT Max',
  'PE1 Einschublaufzeit[zs]' => 'PE1 t marche vis brûleur',
  'PE1 Pausenzeit[zs]' => 'PE1 temps pause',
  'PE1 Luefterdrehzahl[%]' => 'PE1 vitesse V comb',
  'PE1 Saugzugdrehzahl[%]' => 'PE1 vitesse V fumées',
  'PE1 Unterdruck Ist[EH]' => 'PE1 Mesure',
  'PE1 Unterdruck Soll[EH]' => 'PE1 Consigne',
  'PE1 Status' => 'PE1 Etat',
  'PE1 Motor ES' => 'PE1 Moteur vis brûleur',
  'PE1 Motor RA' => 'PE1 Extraction',
  'PE1 Motor RES1' => 'PE1 Moteur réserve 1',
  'PE1 Motor TURBINE' => 'PE1 Turbine',
  'PE1 Motor ZUEND' => 'PE1 Allumeur',
  'PE1 Motor UW[%]' => 'PE1 Pompe chaudière',
  'PE1 Motor AV' => 'PE1 Cendrier',
  'PE1 Motor RES2' => 'PE1 Moteur réserve 2',
  'PE1 Motor MA' => 'PE1 Electro-vanne',
  'PE1 Motor RM' => 'PE1 Moteur ramonage',
  'PE1 Motor SM' => 'PE1 Allumeur',
  'PE1 CAP RA' => 'PE1 Kap RA',
  'PE1 CAP ZB' => 'PE1 Kap ZW',
  'PE1 AK' => 'PE1 Chaud ex (AK)',
  'PE1 Saug-Int[min]' => 'PE1 intervalle aspiration',
  'PE1 DigIn1' => 'PE1 DigIn1',
  'PE1 DigIn2' => 'PE1 DigIn2'
}.freeze

class MeasuresImporter
  def initialize(boiler_url)
    @boiler_url = boiler_url
    @header_errors = Set[]
  end

  def import_all
    files = all_measures_files
    Rails.logger.info "#{files.count} measure file(s) found"
    files.each do |file|
      start = Time.current
      count = import_file(file[:name], file[:link])
      Rails.logger.info "#{count} measure(s) imported in #{Time.current - start}s"
    end
  end

  def all_measures_files
    all_files = Nokogiri::HTML5.get("#{@boiler_url}/logfiles/pelletronic/").search('td a').map do |node|
      { link: @boiler_url + node.attribute('href'), name: node.text }
    end

    all_files.select { |file| /\.csv$/ =~ file[:link] }
             .reject { |file| file[:name] == HEADER_FILE }
  end

  def import_file(file_name, link)
    Rails.logger.info "Import file #{file_name}…"
    ApplicationRecord.transaction do
      Importation.destroy_by file_name: file_name
      importation = Importation.create!(file_name: file_name)
      CsvMeasures.download(link).each_row do |row|
        measure = parse_row(row)
        measure.importation = importation
        measure.save!
      end
    end
  end

  def parse_row(row)
    date = parse_date(row)
    measure = Measure.new(date: date)

    parse_measures(row) do |column_name, value|
      unless metrics_by_csv_column.include? column_name
        add_header_error "Unknown metric '#{column_name}'"
        next
      end

      metric = metrics_by_csv_column[column_name]
      measure.write_attribute(metric.column_name, value)
    end
    measure
  end

  def parse_date(row)
    day = row[0] # ex: 10.12.2020
    time = row[1] # ex: 00:03:24
    DateTime.strptime("#{day.strip} #{time.strip}", '%d.%m.%Y %H:%M:%S')
  end

  def parse_measures(row)
    (2..row.length - 1).each do |index|
      str_value = row[index]
      next if str_value.blank?

      value = str_value.gsub(/,/, '.').to_f
      column_name = row.headers[index]
      yield column_name, value
    end
  end

  def add_header_error(msg)
    Rails.logger.warn(msg) unless @header_errors.add?(msg).nil?
  end

  def metrics_by_csv_column
    if @metrics_by_csv_column.nil?
      all_metrics_by_label = Metric.all.index_by(&:label)
      @metrics_by_csv_column = CSV_MAPPING.transform_values { |label| all_metrics_by_label[label] }
    end
    @metrics_by_csv_column
  end
end
