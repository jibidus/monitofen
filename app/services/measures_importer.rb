require 'nokogumbo'
require 'csv'

HEADER_FILE='titles.csv'

class MeasuresImporter

  def initialize(boiler_url)
    @boiler_url = boiler_url
  end

  def import
    all_remote.each do |daily_measures|
      $stdout.sync = true
      print "import measures from file #{daily_measures[:name]}… "
      client = HTTPClient.new
      content = client.get_content(daily_measures[:link])
      csv = CSV.new(content, col_sep: ';', headers: true)
      ApplicationRecord.transaction do
        imported_file = ImportedFile.create!(name: daily_measures[:name])
        csv.each do |row|
          day = row[0] # 10.12.2020
          time = row[1] # 00:03:24
          date = DateTime.strptime("#{day.strip} #{time.strip}", '%d.%m.%Y %H:%M:%S')
          puts "#{row.length} metric(s) found"
          (2..row.length-1).each do |index|
            metric_name = row.headers[index]
            value = row[index]
            if metric_name.nil? && value.nil?
              # empty column => skip it
              break
            end
            metric = Metric.find_or_create_by!(index: index) do |metric|
              metric.name = metric_name
            end
            value_f = value.gsub(/,/,'.').to_f
            Measure.create!(date: date, metric: metric, value: value_f, imported_file: imported_file)
          rescue e
            puts "Cannot parse following CSV line because or #{e}"
            puts row
            puts "continue…"
          end
        end
      end
    end
  end

  def all_remote
    Nokogiri::HTML5.get("#{@boiler_url}/logfiles/pelletronic/").search('td a').map do |node|
      {link: 'http://192.168.1.23:8080'+node.attribute('href'), name: node.text}
    end.select {|file| /\.csv$/ =~ file[:link]}
    .reject {|file| file[:name] == HEADER_FILE}
  end
end
