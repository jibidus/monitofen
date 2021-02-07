# frozen_string_literal: true

require 'csv'

class CsvFileContent
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
    @csv.each do |row|
      yield CsvRow.new(row, @metric_mapper, @errors)
      rows_count += 1
    rescue StandardError => e
      Rails.logger.error "Cannot parse row: #{row}\n#{e.inspect}"
      raise e
    end
    rows_count
  end

  def print_errors
    @errors.each { |error| Rails.logger.warn error }
  end
end
