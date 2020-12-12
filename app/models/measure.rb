class Measure < ApplicationRecord
	validates :date, :value, presence: true
	validates :date, uniqueness: { scope: :metric }
	belongs_to :metric, optional: false
	belongs_to :imported_file, optional: false
end
