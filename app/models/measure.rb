# frozen_string_literal: true

class Measure < ApplicationRecord
  validates :date, presence: true, uniqueness: true
  belongs_to :importation, optional: false

  def self.find_value!(date, metric_label)
    measure = find_by!(date: date)
    metric = Metric.find_by!(label: metric_label)
    measure.send(metric.column_name)
  end
end
