class ChangeMeasureValueType < ActiveRecord::Migration[6.1]
  def change
  	change_column :measures, :value, :float
  end
end
