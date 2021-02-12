# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_02_12_202620) do

  create_table "importations", force: :cascade do |t|
    t.string "file_name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "status", null: false
  end

  create_table "measures", force: :cascade do |t|
    t.datetime "date", null: false
    t.float "metric_0"
    t.float "metric_1"
    t.float "metric_2"
    t.float "metric_3"
    t.float "metric_4"
    t.float "metric_5"
    t.float "metric_6"
    t.float "metric_7"
    t.float "metric_8"
    t.float "metric_9"
    t.float "metric_10"
    t.float "metric_11"
    t.float "metric_12"
    t.float "metric_13"
    t.float "metric_14"
    t.float "metric_15"
    t.float "metric_16"
    t.float "metric_17"
    t.float "metric_18"
    t.float "metric_19"
    t.float "metric_20"
    t.float "metric_21"
    t.float "metric_22"
    t.float "metric_23"
    t.float "metric_24"
    t.float "metric_25"
    t.float "metric_26"
    t.float "metric_27"
    t.float "metric_28"
    t.float "metric_29"
    t.float "metric_30"
    t.float "metric_31"
    t.float "metric_32"
    t.float "metric_33"
    t.float "metric_34"
    t.float "metric_35"
    t.float "metric_36"
    t.float "metric_37"
    t.float "metric_38"
    t.float "metric_39"
    t.float "metric_40"
    t.float "metric_41"
    t.float "metric_42"
    t.float "metric_43"
    t.float "metric_44"
    t.float "metric_45"
    t.float "metric_46"
    t.float "metric_47"
    t.float "metric_48"
    t.float "metric_49"
    t.float "metric_50"
    t.float "metric_51"
    t.integer "measures_id"
    t.integer "importation_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["date"], name: "index_measures_on_date", unique: true
    t.index ["importation_id"], name: "index_measures_on_importation_id"
    t.index ["measures_id"], name: "index_measures_on_measures_id"
  end

  create_table "metrics", force: :cascade do |t|
    t.string "label", null: false
    t.string "column_name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["column_name"], name: "index_metrics_on_column_name", unique: true
  end

  add_foreign_key "measures", "importations"
  add_foreign_key "measures", "measures", column: "measures_id"
end
