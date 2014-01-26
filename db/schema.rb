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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140126014813) do

  create_table "entries", :force => true do |t|
    t.string   "sbdx_member"
    t.string   "sbdx_member_entry_identifier"
    t.date     "date_missing"
    t.date     "date_recovered"
    t.date     "date_abandoned"
    t.string   "neighborhood"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.string   "brand"
    t.integer  "year"
    t.string   "model"
    t.string   "color"
    t.string   "size"
    t.string   "serial_number"
    t.string   "owner_name"
    t.text     "circumstances"
    t.text     "bicycle_description"
    t.boolean  "reward"
    t.string   "info_url"
    t.string   "sighting_report_url"
    t.text     "sighting_report_instructions"
    t.string   "photo_1_url"
    t.string   "photo_2_url"
    t.string   "photo_3_url"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "entries", ["sbdx_member", "sbdx_member_entry_identifier"], :name => "entry_ak", :unique => true

end
