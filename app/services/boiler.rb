class Boiler
  def initialize(base_url_or_file_path)
    @base_url_or_file_path = base_url_or_file_path
  end

  def files
    if @base_url_or_file_path.match(%r{^https?://})
      Nokogiri::HTML5.get("#{@base_url_or_file_path}/logfiles/pelletronic/")
                     .search('td a')
                     .map do |node|
        BoilerFile.new(node.text, @base_url_or_file_path + node.attribute('href'))
      end
    else
      filename = File.basename(@base_url_or_file_path)
      [BoilerLocalFile.new(filename, @base_url_or_file_path)]
    end
  end

  def measures_files
    files.select(&:measures?)
  end
end
