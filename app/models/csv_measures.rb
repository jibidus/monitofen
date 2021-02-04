# frozen_string_literal: true

class CsvMeasures
  def initialize(content)
    @content = content
  end

  def self.download(url)
    uri = URI(url)
    content = Net::HTTP.get_response(uri).body
    CsvMeasures.new content
  end

  def each_row
    csv = CSV.new(sanitized_content, col_sep: ';', headers: true)
    csv.each do |row|
      yield row
    rescue StandardError => e
      raise "Cannot parse row: #{e.inspect}\n#{row}"
    end
    csv.rewind
    csv.count
  end

  private

  def sanitized_content
    @content.encode("UTF-8", "ISO-8859-1")
            .gsub(/(\n\s*\n)+/, "\n")
  end
end
