require 'net/http'

HEADER_FILE = 'titles.csv'.freeze

class BoilerFile
  attr_reader :name

  def initialize(name, url)
    @name = name
    @path = url
  end

  def measures?
    /\.csv$/ =~ @path && @name != HEADER_FILE
  end

  def incomplete?
    date >= Time.zone.today
  end

  def date
    Date.parse(@name[/\d{8}/, 0])
  end

  def already_imported?
    Importation.exists? file_name: @name, status: :successful
  end

  def content
    uri = URI(@path)
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
