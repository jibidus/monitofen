class AddImportedFileToMeasure < ActiveRecord::Migration[6.1]
  def change
  	add_column :measures, :imported_file_id, :integer, null: false
  	add_foreign_key :measures, :imported_files
  end
end
