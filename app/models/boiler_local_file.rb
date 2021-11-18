# Boiler file available in local file system
class BoilerLocalFile < BoilerFile
  def content
    content = ""
    File.open(@path) do |f|
      content = f.read || ""
    end
    content
  end
end
