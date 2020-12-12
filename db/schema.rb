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

ActiveRecord::Schema.define(version: 2020_12_14_204152) do

  create_table "imported_files", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "measures", force: :cascade do |t|
    t.datetime "date", null: false
    t.integer "metric_id"
    t.float "value", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "imported_file_id", null: false
    t.index ["date", "metric_id"], name: "index_measures_on_date_and_metric_id", unique: true
    t.index ["metric_id"], name: "index_measures_on_metric_id"
  end

  create_table "metrics", force: :cascade do |t|
    t.string "name", null: false
    t.integer "index", null: false
    t.string "translated_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["index"], name: "index_metrics_on_index", unique: true
  end

  add_foreign_key "measures", "imported_files"
  add_foreign_key "measures", "metrics"
end
