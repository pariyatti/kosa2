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

ActiveRecord::Schema[7.0].define(version: 2023_12_31_000752) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "doha_translations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "language"
    t.text "translation"
    t.uuid "doha_id", null: false
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doha_id"], name: "index_doha_translations_on_doha_id"
  end

  create_table "dohas", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "doha"
    t.text "original_doha"
    t.string "original_url"
    t.string "original_audio_url"
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "looped_doha_translations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "language"
    t.text "translation"
    t.uuid "looped_doha_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["looped_doha_id"], name: "index_looped_doha_translations_on_looped_doha_id"
  end

  create_table "looped_dohas", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "index"
    t.text "doha"
    t.text "original_doha"
    t.string "original_url"
    t.string "original_audio_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "looped_pali_word_translations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "language"
    t.text "translation"
    t.uuid "looped_pali_word_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["looped_pali_word_id"], name: "index_looped_pali_word_translations_on_looped_pali_word_id"
  end

  create_table "looped_pali_words", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "index"
    t.string "original_pali"
    t.string "original_url"
    t.string "pali"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "looped_words_of_buddha_translations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "language"
    t.text "translation"
    t.uuid "looped_words_of_buddha_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["looped_words_of_buddha_id"], name: "index_looped_wob_translations_on_looped_wob_id"
  end

  create_table "looped_words_of_buddhas", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "index"
    t.text "words"
    t.string "citepali"
    t.string "citepali_url"
    t.string "citebook"
    t.string "citebook_url"
    t.text "original_words"
    t.string "original_url"
    t.string "original_audio_url"
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pali_word_translations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "language"
    t.text "translation"
    t.uuid "pali_word_id", null: false
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pali_word_id"], name: "index_pali_word_translations_on_pali_word_id"
  end

  create_table "pali_words", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "index"
    t.string "original_pali"
    t.string "original_url"
    t.string "pali"
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "txt_feeds", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "language"
    t.text "sha1_digest"
    t.text "entry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["language", "sha1_digest"], name: "index_txt_feeds_on_language_and_sha1_digest", unique: true
  end

  create_table "words_of_buddha_translations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "language"
    t.text "translation"
    t.uuid "words_of_buddha_id", null: false
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["words_of_buddha_id"], name: "index_wob_translations_on_wob_id"
  end

  create_table "words_of_buddhas", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "words"
    t.string "citepali"
    t.string "citepali_url"
    t.string "citebook"
    t.string "citebook_url"
    t.text "original_words"
    t.string "original_url"
    t.string "original_audio_url"
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "doha_translations", "dohas"
  add_foreign_key "looped_doha_translations", "looped_dohas"
  add_foreign_key "looped_pali_word_translations", "looped_pali_words"
  add_foreign_key "looped_words_of_buddha_translations", "looped_words_of_buddhas"
  add_foreign_key "pali_word_translations", "pali_words"
  add_foreign_key "words_of_buddha_translations", "words_of_buddhas"
end
