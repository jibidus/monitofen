class UpdateImportationStatus < ActiveRecord::Migration[6.1]
  class Importation < ApplicationRecord; end

  def change
    Importation.where(status: :success).update_all status: :successful
  end
end
