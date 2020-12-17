class CreateMetrics < ActiveRecord::Migration[6.1]
  def change
    create_table :metrics do |t|
      t.string :label, null: false
      t.string :column_name, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
