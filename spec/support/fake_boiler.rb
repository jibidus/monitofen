class FakeBoiler
  def self.reset
    @all_file_names = []
    @measure_date = Date.new(2001, 2, 25)
  end

  def self.url
    'http://192.168.1.23:8080'
  end

  def self.stub_measure_file(date: new_date, content: MeasuresFileContent.build(date: date))
    file_name = "touch_#{date.strftime('%Y%m%d')}.csv"
    stub_file file_name, content
  end

  def self.stub_files_index(file_names = [])
    @all_file_names = file_names
    stub_index
  end

  def self.stub_file(file_name, content = "")
    @all_file_names << file_name
    stub_index
    stub_file_content file_name, content
  end

  def self.stub_file_content(file, content)
    WebMock.stub_request(:get,
                         "#{FakeBoiler.url}/logfiles/pelletronic/#{file}").to_return(body: content.encode(
                           "ISO-8859-1", "UTF-8"
                         ))
  end

  def self.new_date
    @measure_date += +1.day
    @measure_date
  end

  # rubocop:disable Metrics/MethodLength
  def self.stub_index
    html = @all_file_names.map do |file_name|
      <<~HTML
        <tr>
          <td><a href=\"/logfiles/pelletronic/#{file_name}\">#{file_name}</a></td>
          <td> 09-Dec-2020 00:00</td>
          <td>  278.7k</td>
        </tr>
      HTML
    end.join('\n')

    body = <<~HTML
      <html>
      <head>
        <title>Index of /logfiles/pelletronic/</title>
      </head>
      <body>
        <h1>Index of /logfiles/pelletronic/</h1>
        <table cellpadding="0">
          <tr><th><a href="?nd">Name</a></th><th><a href="?dd">Modified</a></th><th><a href="?sd">Size</a></th></tr>
          <tr><td colspan="3"><hr></td></tr>
          <tr><td><a href="/logfiles/pelletronic/..">Parent directory</a></td><td> -</td><td>  -</td></tr>
          #{html}
        </table>
      </body></html>
    HTML

    WebMock.stub_request(:get, "#{url}/logfiles/pelletronic/").to_return(body: body)
  end
  # rubocop:enable Metrics/MethodLength

  private_class_method :stub_file_content, :new_date, :stub_index
end
