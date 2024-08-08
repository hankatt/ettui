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

ActiveRecord::Schema.define(version: 2021_12_24_170720) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.integer "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: 6, null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "boards", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "boards_quotes", id: false, force: :cascade do |t|
    t.integer "board_id", null: false
    t.integer "quote_id", null: false
  end

  create_table "letsencrypt_plugin_challenges", force: :cascade do |t|
    t.text "response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "quotes", force: :cascade do |t|
    t.text "text"
    t.string "url"
    t.integer "user_id"
    t.integer "source_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "readability_title"
    t.string "readability_author"
  end

  create_table "quotes_tags", id: false, force: :cascade do |t|
    t.integer "tag_id"
    t.integer "quote_id"
    t.index ["quote_id"], name: "index_quotes_tags_on_quote_id"
    t.index ["tag_id"], name: "index_quotes_tags_on_tag_id"
  end

  create_table "sources", force: :cascade do |t|
    t.string "hostname"
    t.string "favicon"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", id: false, force: :cascade do |t|
    t.integer "board_id"
    t.integer "user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_hash"
    t.string "password_salt"
    t.string "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "uid"
    t.string "provider"
    t.string "name"
    t.boolean "new_user"
    t.datetime "last_active_at"
    t.string "twitter_image_url"
    t.string "twitter_description"
    t.boolean "guest"
    t.string "password_reset_token"
    t.datetime "password_reset_sent_at"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
