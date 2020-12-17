class CreateImportation < ActiveRecord::Migration[6.1]
  def change
    create_table :importations do |t|
      t.string :file_name, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
