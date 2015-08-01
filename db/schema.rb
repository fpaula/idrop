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

ActiveRecord::Schema.define(version: 20150801143329) do

  create_table "candidates", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "nickname",   limit: 255
    t.string   "image_url",  limit: 255
    t.boolean  "status",     limit: 1
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "candidates_categories", force: :cascade do |t|
    t.integer  "category_id",  limit: 4
    t.integer  "candidate_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "candidates_categories", ["category_id", "candidate_id"], name: "index_candidates_categories_on_category_id_and_candidate_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "parent_id",  limit: 4
    t.boolean  "status",     limit: 1,   default: true
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

end
