# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_01_102305) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_grants", force: :cascade do |t|
    t.string "token", null: false
    t.datetime "expired_at", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["expired_at"], name: "index_access_grants_on_expired_at"
    t.index ["token"], name: "index_access_grants_on_token", unique: true
  end

  create_table "infected_keys", force: :cascade do |t|
    t.text "data", null: false
    t.integer "submission_id", null: false
    t.integer "rolling_start_number", null: false
    t.integer "risk_level", default: 0, null: false
    t.index ["submission_id"], name: "index_infected_keys_on_submission_id"
  end

  create_table "submissions", force: :cascade do |t|
    t.integer "result", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "identifier", limit: 36, null: false
    t.datetime "expired_at", null: false
    t.index ["created_at"], name: "index_submissions_on_created_at"
    t.index ["expired_at"], name: "index_submissions_on_expired_at"
    t.index ["identifier"], name: "index_submissions_on_identifier", unique: true
    t.index ["result"], name: "index_submissions_on_result"
    t.index ["updated_at"], name: "index_submissions_on_updated_at"
  end

  add_foreign_key "infected_keys", "submissions"
end
