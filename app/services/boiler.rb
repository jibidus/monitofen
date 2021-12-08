require 'nokogiri'
require 'open-uri'

class Boiler
  def initialize(base_url_or_file_path)
    @base_url_or_file_path = base_url_or_file_path
  end

  def files
    if @base_url_or_file_path.match(%r{^https?://})
      remote_files "#{@base_url_or_file_path}/logfiles/pelletronic/"
    else
      [local_file(@base_url_or_file_path)]
    end
  end

  def measures_files
    files.select(&:measures?)
  end

  private

  def remote_files(uri)
    page_content = URI.parse(uri).open
    Nokogiri::HTML5(page_content)
            .search('td a')
            .map do |node|
      BoilerFile.new node.text, @base_url_or_file_path + node.attribute('href')
    end
  end

  def local_file(file_path)
    filename = File.basename(file_path)
    BoilerLocalFile.new filename, file_path
  end
end
