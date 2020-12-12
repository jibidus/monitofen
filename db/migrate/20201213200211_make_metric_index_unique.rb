class MakeMetricIndexUnique < ActiveRecord::Migration[6.1]
  def change
  	add_index :metrics, :index, unique: true
  end
end
