class BoilerResponse

  def self.build_files_index(files=[])
    html = files.map do |file|
      "<tr><td><a href=\"/logfiles/pelletronic/#{file}\">#{file}</a></td><td> 09-Dec-2020 00:00</td><td>  278.7k</td></tr>"
    end.join("\n")
  	return <<-HTML
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
    <tr><td><a href="/logfiles/pelletronic/graph_20201208.png">graph_20201208.png</a></td><td> 09-Dec-2020 02:01</td><td>  18.6k</td></tr>
    <tr><td><a href="/logfiles/pelletronic/titles.csv">titles.csv</a></td><td> 12-Dec-2020 20:10</td><td>  1.1k</td></tr>
    #{html}
  </table>
</body></html>
HTML
  end

end