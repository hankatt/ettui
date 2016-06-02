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

ActiveRecord::Schema.define(version: 20160602193325) do

  create_table "boards", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "boards_quotes", id: false, force: :cascade do |t|
    t.integer "board_id", null: false
    t.integer "quote_id", null: false
  end

  create_table "quotes", force: :cascade do |t|
    t.text     "text"
    t.string   "url",                limit: 255
    t.integer  "user_id"
    t.integer  "source_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "readability_title",  limit: 255
    t.string   "readability_author", limit: 255
  end

  create_table "quotes_tags", id: false, force: :cascade do |t|
    t.integer "tag_id"
    t.integer "quote_id"
  end

  add_index "quotes_tags", ["quote_id"], name: "index_quotes_tags_on_quote_id"
  add_index "quotes_tags", ["tag_id"], name: "index_quotes_tags_on_tag_id"

  create_table "sources", force: :cascade do |t|
    t.string   "hostname",   limit: 255
    t.string   "favicon",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", id: false, force: :cascade do |t|
    t.integer "board_id"
    t.integer "user_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id"
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true

  create_table "tags", force: :cascade do |t|
    t.string "name", limit: 255, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255
    t.string   "password_hash",          limit: 255
    t.string   "password_salt",          limit: 255
    t.string   "token",                  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uid",                    limit: 255
    t.string   "provider",               limit: 255
    t.string   "name",                   limit: 255
    t.boolean  "new_user"
    t.datetime "last_active_at"
    t.string   "twitter_image_url",      limit: 255
    t.string   "twitter_description",    limit: 255
    t.boolean  "guest"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
  end

end
