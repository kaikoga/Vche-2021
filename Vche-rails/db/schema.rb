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

ActiveRecord::Schema.define(version: 2021_10_03_225811) do

  create_table "accounts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "uid"
    t.string "name"
    t.string "display_name"
    t.bigint "platform_id", null: false
    t.string "url"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["platform_id"], name: "index_accounts_on_platform_id"
    t.index ["uid"], name: "index_accounts_on_uid", unique: true
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "active_admin_comments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "authentications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["provider", "uid"], name: "index_authentications_on_provider_and_uid"
  end

  create_table "categories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "emoji"
    t.string "slug"
    t.string "name"
    t.boolean "available"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["emoji"], name: "index_categories_on_emoji", unique: true
    t.index ["name"], name: "index_categories_on_name", unique: true
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "event_attendances", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "uid"
    t.bigint "user_id", null: false
    t.bigint "event_id", null: false
    t.datetime "started_at", null: false
    t.string "role"
    t.string "hashtag"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_id"], name: "index_event_attendances_on_event_id"
    t.index ["uid"], name: "index_event_attendances_on_uid", unique: true
    t.index ["user_id", "event_id", "started_at"], name: "index_event_attendances_on_user_id_and_event_id_and_started_at", unique: true
    t.index ["user_id"], name: "index_event_attendances_on_user_id"
  end

  create_table "event_flavors", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "event_id"
    t.bigint "flavor_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_id", "flavor_id"], name: "index_event_flavors_on_event_id_and_flavor_id", unique: true
    t.index ["event_id"], name: "index_event_flavors_on_event_id"
    t.index ["flavor_id"], name: "index_event_flavors_on_flavor_id"
  end

  create_table "event_follows", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "event_id", null: false
    t.string "role"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_id"], name: "index_event_follows_on_event_id"
    t.index ["user_id", "event_id"], name: "index_event_follows_on_user_id_and_event_id", unique: true
    t.index ["user_id"], name: "index_event_follows_on_user_id"
  end

  create_table "event_histories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "uid"
    t.bigint "event_id", null: false
    t.string "resolution", null: false
    t.datetime "assembled_at"
    t.datetime "opened_at"
    t.datetime "started_at", null: false
    t.datetime "ended_at", null: false
    t.datetime "closed_at"
    t.bigint "created_user_id"
    t.bigint "updated_user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_user_id"], name: "index_event_histories_on_created_user_id"
    t.index ["event_id", "started_at"], name: "index_event_histories_on_event_id_and_started_at", unique: true
    t.index ["event_id"], name: "index_event_histories_on_event_id"
    t.index ["uid"], name: "index_event_histories_on_uid", unique: true
    t.index ["updated_user_id"], name: "index_event_histories_on_updated_user_id"
  end

  create_table "event_memories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "uid"
    t.bigint "user_id", null: false
    t.bigint "event_id", null: false
    t.datetime "started_at", null: false
    t.datetime "published_at", null: false
    t.string "hashtag"
    t.text "body", null: false
    t.json "urls", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_id"], name: "index_event_memories_on_event_id"
    t.index ["published_at"], name: "index_event_memories_on_published_at"
    t.index ["uid"], name: "index_event_memories_on_uid", unique: true
    t.index ["user_id", "published_at"], name: "index_event_memories_on_user_id_and_published_at"
    t.index ["user_id"], name: "index_event_memories_on_user_id"
  end

  create_table "event_schedules", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "uid"
    t.bigint "event_id", null: false
    t.datetime "assemble_at"
    t.datetime "open_at"
    t.datetime "start_at", null: false
    t.datetime "end_at", null: false
    t.datetime "close_at"
    t.string "repeat"
    t.string "resolution"
    t.datetime "repeat_until"
    t.bigint "created_user_id"
    t.bigint "updated_user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_user_id"], name: "index_event_schedules_on_created_user_id"
    t.index ["event_id"], name: "index_event_schedules_on_event_id"
    t.index ["uid"], name: "index_event_schedules_on_uid", unique: true
    t.index ["updated_user_id"], name: "index_event_schedules_on_updated_user_id"
  end

  create_table "events", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "uid"
    t.string "name"
    t.string "fullname"
    t.string "description"
    t.string "organizer_name"
    t.string "primary_sns"
    t.string "info_url"
    t.string "hashtag"
    t.bigint "platform_id", null: false
    t.bigint "category_id", null: false
    t.string "visibility", null: false
    t.string "taste"
    t.integer "trust"
    t.bigint "created_user_id"
    t.bigint "updated_user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_events_on_category_id"
    t.index ["created_user_id"], name: "index_events_on_created_user_id"
    t.index ["platform_id"], name: "index_events_on_platform_id"
    t.index ["uid"], name: "index_events_on_uid", unique: true
    t.index ["updated_user_id"], name: "index_events_on_updated_user_id"
  end

  create_table "flavors", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "emoji"
    t.string "slug"
    t.string "name"
    t.string "taste"
    t.boolean "available"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["emoji"], name: "index_flavors_on_emoji", unique: true
    t.index ["name"], name: "index_flavors_on_name", unique: true
    t.index ["slug"], name: "index_flavors_on_slug", unique: true
  end

  create_table "hashtag_follows", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "hashtag"
    t.string "role"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id", "hashtag", "role"], name: "index_hashtag_follows_on_user_id_and_hashtag_and_role", unique: true
    t.index ["user_id"], name: "index_hashtag_follows_on_user_id"
  end

  create_table "platforms", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "slug"
    t.string "name"
    t.boolean "available"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_platforms_on_name", unique: true
    t.index ["slug"], name: "index_platforms_on_slug", unique: true
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", null: false
    t.string "uid", null: false
    t.string "display_name"
    t.string "primary_sns"
    t.string "visibility", null: false
    t.integer "trust", null: false
    t.string "user_role", null: false
    t.string "admin_role", null: false
    t.string "profile"
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.datetime "last_login_at"
    t.datetime "last_logout_at"
    t.datetime "last_activity_at"
    t.string "last_login_from_ip_address"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["last_logout_at", "last_activity_at"], name: "index_users_on_last_logout_at_and_last_activity_at"
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token"
  end

  add_foreign_key "accounts", "platforms"
  add_foreign_key "accounts", "users"
  add_foreign_key "event_attendances", "events"
  add_foreign_key "event_attendances", "users"
  add_foreign_key "event_flavors", "events"
  add_foreign_key "event_flavors", "flavors"
  add_foreign_key "event_follows", "events"
  add_foreign_key "event_follows", "users"
  add_foreign_key "event_histories", "events"
  add_foreign_key "event_histories", "users", column: "created_user_id"
  add_foreign_key "event_histories", "users", column: "updated_user_id"
  add_foreign_key "event_memories", "events"
  add_foreign_key "event_memories", "users"
  add_foreign_key "event_schedules", "events"
  add_foreign_key "event_schedules", "users", column: "created_user_id"
  add_foreign_key "event_schedules", "users", column: "updated_user_id"
  add_foreign_key "events", "categories"
  add_foreign_key "events", "platforms"
  add_foreign_key "events", "users", column: "created_user_id"
  add_foreign_key "events", "users", column: "updated_user_id"
  add_foreign_key "hashtag_follows", "users"
end
