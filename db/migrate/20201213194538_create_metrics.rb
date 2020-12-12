class CreateMetrics < ActiveRecord::Migration[6.1]
  def change
    create_table :metrics do |t|
      t.string :name, null: false
      t.integer :index, null: false, unique: true
      t.string :translated_name

      t.timestamps
    end
  end
end
