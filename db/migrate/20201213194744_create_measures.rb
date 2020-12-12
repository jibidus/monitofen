class CreateMeasures < ActiveRecord::Migration[6.1]
  def change
    create_table :measures do |t|
      t.datetime :date, null: false
      t.references :metric, foreign_key: true
      t.integer :value, null: false

      t.timestamps
    end
  end
end
