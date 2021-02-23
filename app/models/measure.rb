class Measure < ApplicationRecord
  validates :date, presence: true, uniqueness: true
  belongs_to :importation, optional: false

  def self.select(metric)
    Measure.all.pluck(:date, metric.column_name)
           .map { |v| { date: v[0], value: v[1] } }
  end
end
