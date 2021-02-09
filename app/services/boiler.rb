class Boiler
  def initialize(base_url)
    @base_url = base_url
  end

  def files
    Nokogiri::HTML5.get("#{@base_url}/logfiles/pelletronic/")
                   .search('td a')
                   .map do |node|
      BoilerFile.new(node.text, @base_url + node.attribute('href'))
    end
  end
end
