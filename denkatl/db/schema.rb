# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20141207154524) do

  create_table "berlin", id: false, force: true do |t|
    t.string "field_1", limit: nil
    t.string "field_2", limit: nil
    t.string "field_3", limit: nil
    t.string "field_4", limit: nil
    t.string "field_5", limit: nil
    t.float  "field_6"
    t.float  "field_7"
  end

  create_table "maps", force: true do |t|
    t.integer  "eid"
    t.string   "web"
    t.text     "adresse"
    t.text     "beschreibung"
    t.text     "bemerkung"
    t.string   "lat"
    t.string   "lng"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
