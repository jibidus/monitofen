class Metric < ApplicationRecord
	validates :name, :index, presence: true
	validates :index, uniqueness: true
end
