require 'net/http'

HEADER_FILE = 'titles.csv'.freeze

class BoilerFile
  attr_reader :name, :url

  def initialize(name, url)
    @name = name
    @url = url
  end

  def measures?
    /\.csv$/ =~ @url && @name != HEADER_FILE
  end

  def complete?
    date != Time.zone.today
  end

  def date
    Date.parse(@name[/\d{8}/, 0])
  end

  def imported?
    Importation.exists? file_name: @name
  end

  def content
    uri = URI(@url)
    Net::HTTP.get_response(uri).body
  end

  def sanitized_content
    content.encode("UTF-8", "ISO-8859-1")
           .gsub(/(\n\s*\n)+/, "\n")
  end

  def csv_content
    CsvFileContent.new(sanitized_content)
  end
end
