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

ActiveRecord::Schema[8.0].define(version: 2025_07_14_041510) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

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

  create_table "css_styles", force: :cascade do |t|
    t.string "style_name", null: false
    t.string "style_color", null: false
    t.string "style_daisyui", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["style_name", "style_color", "style_daisyui"], name: "idx_on_style_name_style_color_style_daisyui_751e22f8a7", unique: true
  end

  create_table "favorites", force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "spot_id", null: false
    t.text "summary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spot_id"], name: "index_favorites_on_spot_id"
    t.index ["user_id", "spot_id"], name: "index_favorites_on_user_id_and_spot_id", unique: true
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "season_tags", force: :cascade do |t|
    t.string "season", null: false
    t.bigint "css_style_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["css_style_id"], name: "index_season_tags_on_css_style_id"
  end

  create_table "spot_season_tags", force: :cascade do |t|
    t.uuid "spot_id", null: false
    t.bigint "season_tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["season_tag_id"], name: "index_spot_season_tags_on_season_tag_id"
    t.index ["spot_id", "season_tag_id"], name: "index_spot_season_tags_on_spot_id_and_season_tag_id", unique: true
    t.index ["spot_id"], name: "index_spot_season_tags_on_spot_id"
  end

  create_table "spots", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "name", null: false
    t.string "spot_image"
    t.string "address"
    t.text "opening_hours"
    t.text "summary"
    t.float "latitude", null: false
    t.float "longitude", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_spots_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", default: "SaitaManear_Account", null: false
    t.integer "role", default: 0, null: false
    t.string "provider"
    t.string "uid"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "favorites", "spots"
  add_foreign_key "favorites", "users"
  add_foreign_key "spots", "users"
end
