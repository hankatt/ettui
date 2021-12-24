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

ActiveRecord::Schema.define(version: 2021_12_24_171236) do

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
    t.string "name", limit: 255
    t.text "description"
    t.integer "user_id"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
  end

  create_table "boards_quotes", id: false, force: :cascade do |t|
    t.integer "board_id", null: false
    t.integer "quote_id", null: false
  end

  create_table "letsencrypt_plugin_challenges", force: :cascade do |t|
    t.text "response"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "quotes", force: :cascade do |t|
    t.text "text"
    t.string "url", limit: 255
    t.integer "user_id"
    t.integer "source_id"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.string "readability_title", limit: 255
    t.string "readability_author", limit: 255
  end

  create_table "quotes_tags", id: false, force: :cascade do |t|
    t.integer "tag_id"
    t.integer "quote_id"
    t.index ["quote_id"], name: "index_quotes_tags_on_quote_id"
    t.index ["tag_id"], name: "index_quotes_tags_on_tag_id"
  end

  create_table "sources", force: :cascade do |t|
    t.string "hostname", limit: 255
    t.string "favicon", limit: 255
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
  end

  create_table "subscriptions", id: false, force: :cascade do |t|
    t.integer "board_id"
    t.integer "user_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer "tag_id"
    t.integer "taggable_id"
    t.string "taggable_type", limit: 255
    t.integer "tagger_id"
    t.string "tagger_type", limit: 255
    t.string "context", limit: 128
    t.datetime "created_at", precision: 6
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", limit: 255, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", limit: 255
    t.string "password_hash", limit: 255
    t.string "password_salt", limit: 255
    t.string "token", limit: 255
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.string "uid", limit: 255
    t.string "provider", limit: 255
    t.string "name", limit: 255
    t.boolean "new_user"
    t.datetime "last_active_at", precision: 6
    t.string "twitter_image_url", limit: 255
    t.string "twitter_description", limit: 255
    t.boolean "guest"
    t.string "password_reset_token"
    t.datetime "password_reset_sent_at", precision: 6
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
