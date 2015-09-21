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

ActiveRecord::Schema.define(version: 20150921210042) do

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "candidate_combinations", force: :cascade do |t|
    t.integer "election_id",    limit: 4
    t.integer "candidate_id_1", limit: 4
    t.integer "candidate_id_2", limit: 4
  end

  add_index "candidate_combinations", ["candidate_id_1"], name: "fk_rails_5d243c522d", using: :btree
  add_index "candidate_combinations", ["candidate_id_2"], name: "fk_rails_71d9e9329b", using: :btree
  add_index "candidate_combinations", ["election_id"], name: "index_candidate_combinations_election_id", using: :btree

  create_table "candidates", force: :cascade do |t|
    t.string   "name",                 limit: 255
    t.string   "nickname",             limit: 255
    t.string   "image_url",            limit: 255
    t.boolean  "status",               limit: 1,   default: true
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "image_original_title", limit: 255
    t.string   "image_original_url",   limit: 255
    t.string   "image_author_name",    limit: 255
    t.string   "image_author_url",     limit: 255
    t.string   "image_license",        limit: 255
    t.string   "modified_image_id",    limit: 255
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
    t.string   "language",   limit: 5,   default: "pt-br"
    t.boolean  "status",     limit: 1,   default: true
    t.string   "slug",       limit: 255
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "categories", ["slug"], name: "index_categories_on_slug", using: :btree

  create_table "elections", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.datetime "start_date"
    t.datetime "finish_date"
    t.integer  "category_id", limit: 4
    t.string   "status",      limit: 255
    t.string   "slug",        limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "elections", ["slug"], name: "index_elections_on_slug", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",           limit: 255, null: false
    t.integer  "sluggable_id",   limit: 4,   null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope",          limit: 255
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.string   "image",                  limit: 255
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "provider",               limit: 255
    t.string   "uid",                    limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["provider"], name: "index_users_on_provider", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", using: :btree

  create_table "vote_summaries", force: :cascade do |t|
    t.integer  "election_id",  limit: 4
    t.integer  "candidate_id", limit: 4
    t.integer  "total_votes",  limit: 4, default: 0
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "votes", force: :cascade do |t|
    t.integer  "election_id",  limit: 4
    t.integer  "candidate_id", limit: 4
    t.integer  "user_id",      limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_foreign_key "candidate_combinations", "candidates", column: "candidate_id_1", on_delete: :cascade
  add_foreign_key "candidate_combinations", "candidates", column: "candidate_id_2", on_delete: :cascade
  add_foreign_key "candidate_combinations", "elections", on_delete: :cascade
end
