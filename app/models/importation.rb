# frozen_string_literal: true

class Importation < ApplicationRecord
  validates :file_name, presence: true, uniqueness: true
  has_many :measures, dependent: :destroy
end
