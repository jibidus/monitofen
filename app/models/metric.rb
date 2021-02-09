class Metric < ApplicationRecord
  validates :label, :column_name, presence: true
  validates :column_name, uniqueness: true
end
