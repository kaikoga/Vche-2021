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

ActiveRecord::Schema.define(version: 2021_07_20_122642) do

  create_table "accounts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "uid"
    t.string "name"
    t.string "display_name"
    t.string "platform"
    t.string "url"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["uid"], name: "index_accounts_on_uid", unique: true
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "authentications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["provider", "uid"], name: "index_authentications_on_provider_and_uid"
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

  create_table "event_follows", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "event_id", null: false
    t.string "role"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_id"], name: "index_event_follows_on_event_id"
    t.index ["user_id"], name: "index_event_follows_on_user_id"
  end

  create_table "event_histories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "uid"
    t.bigint "event_id", null: false
    t.string "visibility"
    t.string "resolution"
    t.datetime "assembled_at"
    t.datetime "opened_at"
    t.datetime "started_at", null: false
    t.datetime "ended_at", null: false
    t.datetime "closed_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_id"], name: "index_event_histories_on_event_id"
    t.index ["uid"], name: "index_event_histories_on_uid", unique: true
  end

  create_table "event_schedules", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "uid"
    t.bigint "event_id", null: false
    t.string "visibility"
    t.datetime "assemble_at"
    t.datetime "open_at"
    t.datetime "start_at", null: false
    t.datetime "end_at", null: false
    t.datetime "close_at"
    t.json "repeat"
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
    t.string "hashtag"
    t.string "platform"
    t.string "visibility"
    t.integer "trust"
    t.bigint "created_user_id"
    t.bigint "updated_user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_user_id"], name: "index_events_on_created_user_id"
    t.index ["hashtag"], name: "index_events_on_hashtag", unique: true
    t.index ["uid"], name: "index_events_on_uid", unique: true
    t.index ["updated_user_id"], name: "index_events_on_updated_user_id"
  end

  create_table "hashtag_follows", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "hashtag"
    t.string "role"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_hashtag_follows_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", null: false
    t.string "uid", null: false
    t.string "display_name"
    t.string "visibility", null: false
    t.integer "trust", null: false
    t.string "user_role", null: false
    t.string "admin_role", null: false
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
    t.index ["uid"], name: "index_users_on_uid", unique: true
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "event_attendances", "events"
  add_foreign_key "event_attendances", "users"
  add_foreign_key "event_follows", "events"
  add_foreign_key "event_follows", "users"
  add_foreign_key "event_histories", "events"
  add_foreign_key "event_schedules", "events"
  add_foreign_key "event_schedules", "users", column: "created_user_id"
  add_foreign_key "event_schedules", "users", column: "updated_user_id"
  add_foreign_key "events", "users", column: "created_user_id"
  add_foreign_key "events", "users", column: "updated_user_id"
  add_foreign_key "hashtag_follows", "users"
end
