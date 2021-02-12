class RemoveImportationUniqueIndex < ActiveRecord::Migration[6.1]
  def change
    remove_index :importations, name: "index_importations_on_file_name"
  end
end
