# TODO: fix name (does not contain measurement/metric semantic whereas implementation does)
# Row of a measurements file. Content looks like this:
#         Datum ;Zeit ;AT [°C];KT Ist [°C];
#         10.12.2020;00:03:24;2,4;39,6;
class CsvRow
  def initialize(row, metric_mapper, errors)
    @row = row
    @metric_mapper = metric_mapper
    @errors = errors
  end

  def parse
    measurement = Measurement.new(date: date)
    each_value do |column_name, value|
      metric = @metric_mapper.find(column_name)
      if metric.nil?
        @errors << "Unknown metric column '#{column_name}'"
        next
      end

      measurement.write_attribute(metric.column_name, value)
    end
    measurement
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
