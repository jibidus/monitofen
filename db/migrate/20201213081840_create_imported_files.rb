class CreateImportedFiles < ActiveRecord::Migration[6.1]
  def change
    create_table :imported_files do |t|
      t.string :name

      t.timestamps
    end
  end
end
