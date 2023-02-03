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

ActiveRecord::Schema[7.0].define(version: 2012_09_09_235526) do
  create_table "adapters", force: :cascade do |t|
    t.integer "connector_type_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "booking_statuses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "bookings", force: :cascade do |t|
    t.integer "status_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "state_id"
  end

  create_table "colors", force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_colors_on_name", unique: true
  end

  create_table "connector_types", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.string "description"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "has_sound", null: false
    t.index ["name"], name: "index_connector_types_on_name", unique: true
  end

  create_table "fruits", force: :cascade do |t|
    t.string "fruit_name", null: false
    t.string "description"
    t.index ["fruit_name"], name: "index_fruits_on_fruit_name", unique: true
  end

  create_table "states", force: :cascade do |t|
    t.string "state_code"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "virtual_enums", force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_virtual_enums_on_name", unique: true
  end

  create_table "widgets", force: :cascade do |t|
    t.integer "connector_type_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

end
