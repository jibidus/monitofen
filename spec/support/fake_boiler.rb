# frozen_string_literal: true

class FakeBoiler
  def self.url
    'http://192.168.1.23:8080'
  end

  def self.stub_files(files = []) # rubocop:disable Metrics/MethodLength
    html = files.map do |file|
      <<~HTML
        <tr>
          <td><a href=\"/logfiles/pelletronic/#{file}\">#{file}</a></td>
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

  def self.stub_file(file, content)
    WebMock.stub_request(:get,
                         "#{FakeBoiler.url}/logfiles/pelletronic/#{file}").to_return(body: content.encode(
                           "ISO-8859-1", "UTF-8"
                         ))
  end
end
