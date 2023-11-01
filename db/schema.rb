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

ActiveRecord::Schema[7.1].define(version: 2023_10_28_125012) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "address", null: false
    t.string "number"
    t.string "district", null: false
    t.string "city", null: false
    t.string "state", null: false
    t.string "zip", null: false
    t.integer "proponent_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["zip"], name: "index_addresses_on_zip", unique: true
  end

  create_table "contacts", force: :cascade do |t|
    t.string "number", null: false
    t.integer "proponent_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "proponents", force: :cascade do |t|
    t.string "name", null: false
    t.string "taxpayer_number", null: false
    t.date "birthdate", null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.decimal "discount_amount", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "fee", default: "0", null: false
    t.index ["fee"], name: "index_proponents_on_fee"
  end

  add_foreign_key "addresses", "proponents"
  add_foreign_key "contacts", "proponents"
end
