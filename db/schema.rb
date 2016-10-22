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

ActiveRecord::Schema.define(version: 20161014145307) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "steam_market_item_history_prices", force: :cascade do |t|
    t.integer  "app_id",          null: false
    t.integer  "item_id",         null: false
    t.integer  "total_amount"
    t.float    "all_time_median"
    t.integer  "last_30_amount"
    t.float    "last_30_median"
    t.integer  "last_7_amount"
    t.float    "last_7_median"
    t.integer  "last_24h_amount"
    t.float    "last_24h_median"
    t.datetime "fetched_at"
    t.datetime "updated_at",      null: false
    t.index ["app_id", "item_id"], name: "index_steam_market_item_history_prices_on_app_id_and_item_id", unique: true, using: :btree
    t.index ["item_id"], name: "index_steam_market_item_history_prices_on_item_id", using: :btree
  end

  create_table "steam_market_item_prices", force: :cascade do |t|
    t.string   "name",                    null: false
    t.integer  "volume",                  null: false
    t.money    "lowest_price",  scale: 2, null: false
    t.money    "median_price",  scale: 2, null: false
    t.string   "currency",                null: false
    t.text     "response",                null: false
    t.integer  "response_code",           null: false
    t.integer  "app_id",                  null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["app_id", "name"], name: "index_steam_market_item_prices_on_app_id_and_name", using: :btree
    t.index ["app_id"], name: "index_steam_market_item_prices_on_app_id", using: :btree
    t.index ["name"], name: "index_steam_market_item_prices_on_name", using: :btree
  end

  create_table "steam_market_items", force: :cascade do |t|
    t.text     "name",        null: false
    t.integer  "app_id",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "item_nameid"
    t.index ["app_id", "name"], name: "index_steam_market_items_on_app_id_and_name", unique: true, using: :btree
    t.index ["name"], name: "index_steam_market_items_on_name", using: :btree
  end

end
