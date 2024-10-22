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

ActiveRecord::Schema[8.0].define(version: 2024_10_20_162232) do
  create_table "captured_endpoints", force: :cascade do |t|
    t.string "method"
    t.string "url"
    t.text "params"
    t.text "headers"
    t.text "payload"
    t.integer "status"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "captured_requests", force: :cascade do |t|
    t.string "ref_id"
    t.string "method"
    t.string "url"
    t.text "headers"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "captured_responses", force: :cascade do |t|
    t.integer "captured_request_id", null: false
    t.integer "status"
    t.text "headers"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["captured_request_id"], name: "index_captured_responses_on_captured_request_id"
  end

  create_table "profiles", id: :string, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.text "content"
    t.text "providers"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "providers", id: :string, force: :cascade do |t|
    t.string "name"
    t.text "info"
    t.string "api_key"
    t.string "url"
    t.string "chat_path"
    t.string "models_path"
    t.string "default_model"
    t.text "models"
    t.boolean "profilable"
    t.text "payload_options"
    t.text "headers_options"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "captured_responses", "captured_requests"
end
