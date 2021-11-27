class Measure < ApplicationRecord
  validates :date, presence: true, uniqueness: true
  belongs_to :importation, optional: false

  scope :taken, ->(day) { where(date: day.beginning_of_day..day.end_of_day) }
end
