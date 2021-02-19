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

ActiveRecord::Schema.define(version: 2021_02_19_125002) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "candidates", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.boolean "is_profile_complete"
    t.string "invite_status"
    t.boolean "is_qualified"
    t.bigint "drive_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["drive_id"], name: "index_candidates_on_drive_id"
  end

  create_table "drives", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "start_time"
    t.datetime "end_time"
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_drives_on_created_by_id"
    t.index ["organization_id"], name: "index_drives_on_organization_id"
    t.index ["updated_by_id"], name: "index_drives_on_updated_by_id"
  end

  create_table "drives_problems", force: :cascade do |t|
    t.bigint "drive_id"
    t.bigint "problem_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["drive_id"], name: "index_drives_problems_on_drive_id"
    t.index ["problem_id"], name: "index_drives_problems_on_problem_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "email"
    t.string "contact_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "problems", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_problems_on_created_by_id"
    t.index ["organization_id"], name: "index_problems_on_organization_id"
    t.index ["updated_by_id"], name: "index_problems_on_updated_by_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "submissions", force: :cascade do |t|
    t.text "answer"
    t.bigint "candidate_id", null: false
    t.bigint "problem_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["candidate_id"], name: "index_submissions_on_candidate_id"
    t.index ["problem_id"], name: "index_submissions_on_problem_id"
  end

  create_table "test_case_results", force: :cascade do |t|
    t.boolean "is_passed"
    t.bigint "submission_id", null: false
    t.bigint "test_case_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["submission_id"], name: "index_test_case_results_on_submission_id"
    t.index ["test_case_id"], name: "index_test_case_results_on_test_case_id"
  end

  create_table "test_cases", force: :cascade do |t|
    t.string "input"
    t.string "output"
    t.integer "marks"
    t.bigint "problem_id", null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_test_cases_on_created_by_id"
    t.index ["problem_id"], name: "index_test_cases_on_problem_id"
    t.index ["updated_by_id"], name: "index_test_cases_on_updated_by_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password"
    t.bigint "organization_id", null: false
    t.bigint "role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  add_foreign_key "candidates", "drives", column: "drive_id"
  add_foreign_key "drives", "organizations"
  add_foreign_key "drives", "users", column: "created_by_id"
  add_foreign_key "drives", "users", column: "updated_by_id"
  add_foreign_key "drives_problems", "drives", column: "drive_id"
  add_foreign_key "drives_problems", "problems"
  add_foreign_key "problems", "organizations"
  add_foreign_key "problems", "users", column: "created_by_id"
  add_foreign_key "problems", "users", column: "updated_by_id"
  add_foreign_key "submissions", "candidates"
  add_foreign_key "submissions", "problems"
  add_foreign_key "test_case_results", "submissions"
  add_foreign_key "test_case_results", "test_cases"
  add_foreign_key "test_cases", "problems"
  add_foreign_key "test_cases", "users", column: "created_by_id"
  add_foreign_key "test_cases", "users", column: "updated_by_id"
  add_foreign_key "users", "organizations"
  add_foreign_key "users", "roles"
end
