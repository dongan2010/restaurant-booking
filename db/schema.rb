# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_06_18_160753) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "restaurant_id"
    t.datetime "time_from"
    t.datetime "time_to"
    t.index ["restaurant_id"], name: "index_bookings_on_restaurant_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "bookings_tables", id: false, force: :cascade do |t|
    t.bigint "booking_id"
    t.bigint "table_id"
    t.index ["booking_id"], name: "index_bookings_tables_on_booking_id"
    t.index ["table_id"], name: "index_bookings_tables_on_table_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.datetime "working_from"
    t.datetime "working_to"
  end

  create_table "tables", force: :cascade do |t|
    t.bigint "restaurant_id"
    t.integer "number"
    t.index ["restaurant_id"], name: "index_tables_on_restaurant_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
  end

  add_foreign_key "bookings", "restaurants"
  add_foreign_key "bookings", "users"
  add_foreign_key "bookings_tables", "bookings"
  add_foreign_key "bookings_tables", "tables"
  add_foreign_key "tables", "restaurants"
end
