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

ActiveRecord::Schema.define(version: 20160418105228) do

  create_table "photos", force: :cascade do |t|
    t.string   "item_name"
    t.integer  "user_id"
    t.text     "content"
    t.float    "item_value"
    t.date     "item_date"
    t.time     "item_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "image"
    t.text     "item_tag"
  end

  add_index "photos", ["user_id", "created_at"], name: "index_photos_on_user_id_and_created_at"
  add_index "photos", ["user_id"], name: "index_photos_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "description"
    t.string   "height"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "pairuser_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["pairuser_id"], name: "index_users_on_pairuser_id"

end
