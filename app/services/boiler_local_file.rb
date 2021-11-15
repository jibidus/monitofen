class BoilerLocalFile
  attr_reader :name

  def initialize(name, path)
    @name = name
    @path = path
  end

  def measures?
    /\.csv$/ =~ @path
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
    content = ""
    File.open(@path) do |f|
      content = f.read
    end
    content
  end

  def sanitized_content
    content.encode("UTF-8", "ISO-8859-1")
           .gsub(/(\n\s*\n)+/, "\n")
  end

  def csv_content
    CsvFileContent.new(sanitized_content)
  end
end
