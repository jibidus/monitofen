require 'csv'

# TODO: fix name (does not contain measure/metric semantic whereas implementation does)
# rubocop:disable Style/AsciiComments
# Content of a measures file. Looks like this:
#   Datum ;Zeit ;AT [°C];KT Ist [°C];
#   10.12.2020;00:03:24;2,4;39,6;
#   10.13.2020;00:03:25;2,5;39,8;
# rubocop:enable Style/AsciiComments
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
