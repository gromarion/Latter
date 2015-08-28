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

ActiveRecord::Schema.define(version: 20150828022858) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "alerts", force: :cascade do |t|
    t.string   "title"
    t.text     "message",                      null: false
    t.datetime "expire_at"
    t.datetime "activate_at",                  null: false
    t.string   "category",    default: "info", null: false
  end

  create_table "awards", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "badge_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "award_date"
    t.datetime "expiry"
  end

  create_table "badges", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "award_rule"
    t.integer  "award_rule_count", default: 0
    t.boolean  "allow_duplicates", default: false
    t.integer  "expire_in_days",   default: 0
  end

  create_table "games", force: :cascade do |t|
    t.integer  "challenger_id",                            null: false
    t.integer  "challenged_id",                            null: false
    t.boolean  "complete",                 default: false, null: false
    t.float    "result"
    t.string   "score"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "winner_id"
    t.decimal  "challenger_rating_change"
    t.decimal  "challenged_rating_change"
  end

  add_index "games", ["challenged_id"], name: "index_games_on_challenged_id", using: :btree
  add_index "games", ["challenger_id", "challenged_id"], name: "index_games_on_challenger_id_and_challenged_id", using: :btree
  add_index "games", ["challenger_id"], name: "index_games_on_challenger_id", using: :btree
  add_index "games", ["complete"], name: "index_games_on_complete", using: :btree

  create_table "players", force: :cascade do |t|
    t.string   "email",                                   default: "",    null: false
    t.string   "encrypted_password",                      default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                           default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name",                                                    null: false
    t.integer  "rating",                                  default: 1000,  null: false
    t.boolean  "pro",                                     default: false, null: false
    t.boolean  "starter",                                 default: true,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.boolean  "changed_password",                        default: false, null: false
    t.boolean  "wants_challenge_completed_notifications", default: true,  null: false
    t.boolean  "active",                                  default: true,  null: false
    t.string   "authentication_token",                    default: "",    null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "image_url"
  end

  add_index "players", ["active"], name: "index_players_on_active", using: :btree
  add_index "players", ["authentication_token"], name: "index_players_on_authentication_token", unique: true, using: :btree
  add_index "players", ["confirmation_token"], name: "index_players_on_confirmation_token", unique: true, using: :btree
  add_index "players", ["email"], name: "index_players_on_email", unique: true, using: :btree
  add_index "players", ["reset_password_token"], name: "index_players_on_reset_password_token", unique: true, using: :btree

end
