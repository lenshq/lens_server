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

ActiveRecord::Schema.define(version: 20151011215228) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "application_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "application_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "application_users", ["application_id"], name: "index_application_users_on_application_id", using: :btree
  add_index "application_users", ["user_id"], name: "index_application_users_on_user_id", using: :btree

  create_table "applications", force: :cascade do |t|
    t.string   "title",       null: false
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "token",       null: false
    t.string   "domain"
  end

  add_index "applications", ["token"], name: "index_applications_on_token", unique: true, using: :btree

  create_table "event_sources", force: :cascade do |t|
    t.integer  "application_id"
    t.string   "source"
    t.string   "endpoint"
    t.integer  "pages_count"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "events", force: :cascade do |t|
    t.integer  "page_id"
    t.string   "event_type"
    t.text     "content"
    t.float    "duration"
    t.integer  "position"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.float    "started_at"
    t.float    "finished_at"
  end

  create_table "pages", force: :cascade do |t|
    t.integer  "application_id"
    t.string   "controller"
    t.string   "action"
    t.float    "duration"
    t.integer  "events_count"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "raw_event_id"
    t.integer  "event_source_id"
    t.float    "started_at"
    t.float    "finished_at"
  end

  create_table "raw_events", force: :cascade do |t|
    t.integer  "application_id"
    t.text     "data"
    t.string   "state"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
    t.string   "nickname"
    t.string   "image"
    t.integer  "uid"
    t.string   "token"
    t.string   "api_token"
  end

  add_foreign_key "application_users", "applications"
  add_foreign_key "application_users", "users"
end
