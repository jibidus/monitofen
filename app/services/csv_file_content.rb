require 'csv'

class CsvFileContent
  class RowError < StandardError
    def initialize(row, row_number, cause)
      @row = row
      super "Cannot parse row ##{row_number}: #{row}\n#{cause.inspect}"
    end
  end

  def initialize(content)
    @csv = CSV.new(content, col_sep: ';', headers: true)
    @metric_mapper = CsvMetricMapper.new
    @errors = Set.new
  end

  def import!
    measures_count = each_row do |row|
      measure = row.parse
      yield measure
      measure.save!
    end
    print_errors
    measures_count
  end

  private

  def each_row
    rows_count = 0
    @csv.each.with_index(2) do |row, row_number|
      yield CsvRow.new(row, @metric_mapper, @errors)
      rows_count += 1
    rescue StandardError => e
      raise RowError.new(row, row_number, e)
    end
    rows_count
  end

  def print_errors
    @errors.each { |error| Rails.logger.warn error }
  end
end
