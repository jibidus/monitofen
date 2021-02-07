# frozen_string_literal: true

class CsvRow
  def initialize(row, metric_mapper, errors)
    @row = row
    @metric_mapper = metric_mapper
    @errors = errors
  end

  def parse
    measure = Measure.new(date: date)
    each_value do |column_name, value|
      metric = @metric_mapper.find(column_name)
      if metric.nil?
        @errors << "Unknown metric column '#{column_name}'"
        next
      end

      measure.write_attribute(metric.column_name, value)
    end
    measure
  end

  private

  DATE_COLUMN_INDEX = 0
  TIME_COLUMN_INDEX = 1
  FIRST_VALUE_COLUMN_INDEX = 2

  def date
    day = @row[DATE_COLUMN_INDEX] # ex: 10.12.2020
    time = @row[TIME_COLUMN_INDEX] # ex: 00:03:24
    DateTime.strptime("#{day.strip} #{time.strip}", '%d.%m.%Y %H:%M:%S')
  end

  def each_value
    (FIRST_VALUE_COLUMN_INDEX..@row.length - 1).each do |index|
      str_value = @row[index]
      next if str_value.blank?

      value = str_value.gsub(/,/, '.').to_f
      column_name = @row.headers[index]
      yield column_name, value
    end
  end
end
