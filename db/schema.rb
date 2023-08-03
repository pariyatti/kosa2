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

ActiveRecord::Schema[7.0].define(version: 2023_08_02_200138) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "looped_pali_word_translations", force: :cascade do |t|
    t.string "language"
    t.text "translation"
    t.bigint "looped_pali_word_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["looped_pali_word_id"], name: "index_looped_pali_word_translations_on_looped_pali_word_id"
  end

  create_table "looped_pali_words", force: :cascade do |t|
    t.bigint "index"
    t.string "original_pali"
    t.string "original_url"
    t.string "pali"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pali_word_translations", force: :cascade do |t|
    t.string "language"
    t.text "translation"
    t.bigint "pali_word_id", null: false
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pali_word_id"], name: "index_pali_word_translations_on_pali_word_id"
  end

  create_table "pali_words", force: :cascade do |t|
    t.bigint "index"
    t.string "original_pali"
    t.string "original_url"
    t.string "pali"
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "looped_pali_word_translations", "looped_pali_words"
  add_foreign_key "pali_word_translations", "pali_words"
end
