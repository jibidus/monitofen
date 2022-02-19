class Measure < ApplicationRecord
  validates :date, presence: true, uniqueness: true
  belongs_to :importation, optional: false

  scope :taken, ->(day) { where(date: day.all_day) }
end
