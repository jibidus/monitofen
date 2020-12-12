class MakeMeasuresUniqueForEachDate < ActiveRecord::Migration[6.1]
  def change
  	add_index :measures, [:date, :metric_id], unique: true
  end
end
