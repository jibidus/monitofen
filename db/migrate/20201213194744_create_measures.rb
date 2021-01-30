class CreateMeasures < ActiveRecord::Migration[6.1]
  def change
    create_table :measures do |t|
      t.datetime :date, null: false, index: { unique: true }
      t.float :metric_0
      t.float :metric_1
      t.float :metric_2
      t.float :metric_3
      t.float :metric_4
      t.float :metric_5
      t.float :metric_6
      t.float :metric_7
      t.float :metric_8
      t.float :metric_9
      t.float :metric_10
      t.float :metric_11
      t.float :metric_12
      t.float :metric_13
      t.float :metric_14
      t.float :metric_15
      t.float :metric_16
      t.float :metric_17
      t.float :metric_18
      t.float :metric_19
      t.float :metric_20
      t.float :metric_21
      t.float :metric_22
      t.float :metric_23
      t.float :metric_24
      t.float :metric_25
      t.float :metric_26
      t.float :metric_27
      t.float :metric_28
      t.float :metric_29
      t.float :metric_30
      t.float :metric_31
      t.float :metric_32
      t.float :metric_33
      t.float :metric_34
      t.float :metric_35
      t.float :metric_36
      t.float :metric_37
      t.float :metric_38
      t.float :metric_39
      t.float :metric_40
      t.float :metric_41
      t.float :metric_42
      t.float :metric_43
      t.float :metric_44
      t.float :metric_45
      t.float :metric_46
      t.float :metric_47
      t.float :metric_48
      t.float :metric_49
      t.float :metric_50
      t.float :metric_51
      t.references :measures, :importation, foreign_key: true
      t.timestamps
    end
  end
end
