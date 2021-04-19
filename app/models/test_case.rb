# frozen_string_literal: true

class TestCase < ApplicationRecord
  default_scope { where(is_active: true) }
  belongs_to :problem
  belongs_to :updated_by, class_name: 'User', foreign_key: 'updated_by_id'
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'
  has_one :test_case_result
end
