# frozen_string_literal: true

require 'nokogumbo'
require 'csv'
require 'net/http'
require 'uri'

HEADER_FILE = 'titles.csv'

class MeasuresImporter
  def initialize(boiler_url)
    @boiler_url = boiler_url
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
    uri = URI(link)
    content = Net::HTTP.get_response(uri)
                       .body
                       .encode("UTF-8","ISO-8859-1")
                       .gsub(/(\n\s*\n)+/, "\n")
    csv = CSV.new(content, col_sep: ';', headers: true)

    metrics_by_csv_column = Metric.all_by_csv_column

    ApplicationRecord.transaction do
      Importation.destroy_by file_name: file_name
      importation = Importation.create!(file_name: file_name)
      csv.each do |row|
        measure = Measure.new_from_csv(row, metrics_by_csv_column)
        measure.importation = importation
        measure.save!
      rescue => e
        raise "Cannot parse row: #{e.inspect}\n#{row}"
      end
    end
    csv.rewind
    csv.count
  end
end
