class Measure < ApplicationRecord
  validates :date, presence: true, uniqueness: true
  belongs_to :importation, optional: false
end
