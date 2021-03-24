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

ActiveRecord::Schema.define(version: 20_210_316_113_750) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'active_admin_comments', force: :cascade do |t|
    t.string 'namespace'
    t.text 'body'
    t.string 'resource_type'
    t.bigint 'resource_id'
    t.string 'author_type'
    t.bigint 'author_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[author_type author_id], name: 'index_active_admin_comments_on_author_type_and_author_id'
    t.index ['namespace'], name: 'index_active_admin_comments_on_namespace'
    t.index %w[resource_type resource_id], name: 'index_active_admin_comments_on_resource_type_and_resource_id'
  end

  create_table 'assessments', force: :cascade do |t|
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'candidates', force: :cascade do |t|
    t.string 'first_name'
    t.string 'last_name'
    t.string 'email'
    t.boolean 'is_profile_complete'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'mobile_number'
  end

  create_table 'drives', force: :cascade do |t|
    t.string 'name'
    t.text 'description'
    t.datetime 'start_time'
    t.datetime 'end_time'
    t.bigint 'created_by_id'
    t.bigint 'updated_by_id'
    t.bigint 'organization_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'duration'
    t.index ['created_by_id'], name: 'index_drives_on_created_by_id'
    t.index ['organization_id'], name: 'index_drives_on_organization_id'
    t.index ['updated_by_id'], name: 'index_drives_on_updated_by_id'
  end

  create_table 'drives_candidates', force: :cascade do |t|
    t.bigint 'drive_id'
    t.bigint 'candidate_id'
    t.string 'token'
    t.datetime 'email_sent_at'
    t.datetime 'start_time'
    t.datetime 'end_time'
    t.string 'invite_status'
    t.boolean 'is_qualified'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['candidate_id'], name: 'index_drives_candidates_on_candidate_id'
    t.index ['drive_id'], name: 'index_drives_candidates_on_drive_id'
  end

  create_table 'drives_problems', force: :cascade do |t|
    t.bigint 'drive_id'
    t.bigint 'problem_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['drive_id'], name: 'index_drives_problems_on_drive_id'
    t.index ['problem_id'], name: 'index_drives_problems_on_problem_id'
  end

  create_table 'organizations', force: :cascade do |t|
    t.string 'name'
    t.text 'description'
    t.string 'email'
    t.string 'contact_number'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'problems', force: :cascade do |t|
    t.string 'title'
    t.text 'description'
    t.bigint 'created_by_id'
    t.bigint 'updated_by_id'
    t.bigint 'organization_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'submission_count'
    t.index ['created_by_id'], name: 'index_problems_on_created_by_id'
    t.index ['organization_id'], name: 'index_problems_on_organization_id'
    t.index ['updated_by_id'], name: 'index_problems_on_updated_by_id'
  end

  create_table 'roles', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'rules', force: :cascade do |t|
    t.string 'type_name'
    t.text 'description'
    t.bigint 'drive_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['drive_id'], name: 'index_rules_on_drive_id'
  end

  create_table 'samples', force: :cascade do |t|
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'submissions', force: :cascade do |t|
    t.text 'answer'
    t.bigint 'candidate_id', null: false
    t.bigint 'problem_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['candidate_id'], name: 'index_submissions_on_candidate_id'
    t.index ['problem_id'], name: 'index_submissions_on_problem_id'
  end

  create_table 'test_case_results', force: :cascade do |t|
    t.boolean 'is_passed'
    t.bigint 'submission_id', null: false
    t.bigint 'test_case_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['submission_id'], name: 'index_test_case_results_on_submission_id'
    t.index ['test_case_id'], name: 'index_test_case_results_on_test_case_id'
  end

  create_table 'test_cases', force: :cascade do |t|
    t.string 'input'
    t.string 'output'
    t.integer 'marks'
    t.bigint 'problem_id', null: false
    t.bigint 'created_by_id'
    t.bigint 'updated_by_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['created_by_id'], name: 'index_test_cases_on_created_by_id'
    t.index ['problem_id'], name: 'index_test_cases_on_problem_id'
    t.index ['updated_by_id'], name: 'index_test_cases_on_updated_by_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'first_name'
    t.string 'last_name'
    t.bigint 'organization_id', null: false
    t.bigint 'role_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['organization_id'], name: 'index_users_on_organization_id'
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
    t.index ['role_id'], name: 'index_users_on_role_id'
  end

  add_foreign_key 'drives', 'organizations'
  add_foreign_key 'drives', 'users', column: 'created_by_id'
  add_foreign_key 'drives', 'users', column: 'updated_by_id'
  add_foreign_key 'drives_problems', 'drives', column: 'drive_id'
  add_foreign_key 'drives_problems', 'problems'
  add_foreign_key 'problems', 'organizations'
  add_foreign_key 'problems', 'users', column: 'created_by_id'
  add_foreign_key 'problems', 'users', column: 'updated_by_id'
  add_foreign_key 'rules', 'drives', column: 'drive_id'
  add_foreign_key 'submissions', 'candidates'
  add_foreign_key 'submissions', 'problems'
  add_foreign_key 'test_case_results', 'submissions'
  add_foreign_key 'test_case_results', 'test_cases'
  add_foreign_key 'test_cases', 'problems'
  add_foreign_key 'test_cases', 'users', column: 'created_by_id'
  add_foreign_key 'test_cases', 'users', column: 'updated_by_id'
  add_foreign_key 'users', 'organizations'
  add_foreign_key 'users', 'roles'
end
