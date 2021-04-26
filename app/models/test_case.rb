# frozen_string_literal: true

# == Schema Information
#
# Table name: test_cases
#
#  id            :bigint           not null, primary key
#  input         :string
#  output        :string
#  marks         :integer
#  problem_id    :bigint           not null
#  created_by_id :bigint
#  updated_by_id :bigint
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  is_active     :boolean
#
class TestCase < ApplicationRecord
  default_scope { where(is_active: true) }
  belongs_to :problem
  belongs_to :updated_by, class_name: 'User', foreign_key: 'updated_by_id'
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'
  has_one :test_case_result
end
