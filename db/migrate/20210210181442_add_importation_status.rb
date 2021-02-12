class AddImportationStatus < ActiveRecord::Migration[6.1]
  def up
    add_column :importations, :status,:string, null: true
    Importation.update_all status: :success
    change_column :importations, :status,:string, null: false
  end

  def down
    remove_column :importations, :status
  end
end
