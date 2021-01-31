# frozen_string_literal: true

class Measure < ApplicationRecord
  validates :date, presence: true, uniqueness: true
  belongs_to :importation, optional: false

  def self.find_value!(date, metric_label)
    measure = find_by!(date: date)
    metric = Metric.find_by!(label: metric_label)
    measure.send(metric.column_name)
  end

  def self.new_from_csv(row, metrics_by_csv_column)
    day = row[0] # ex: 10.12.2020
    time = row[1] # ex: 00:03:24
    date = DateTime.strptime("#{day.strip} #{time.strip}", '%d.%m.%Y %H:%M:%S')

    measure = Measure.new(date: date)

    (2..row.length - 1).each do |index|
      value = row[index]
      next if value.blank?

      value_f = value.gsub(/,/, '.').to_f

      metric_key = row.headers[index]
      unless metrics_by_csv_column.include? metric_key
        Rails.logger.warn "Unknown metric '#{metric_key}'"
        next
      end

      metric = metrics_by_csv_column[metric_key]
      measure.write_attribute(metric.column_name, value_f)
    end
    measure
  end
end
