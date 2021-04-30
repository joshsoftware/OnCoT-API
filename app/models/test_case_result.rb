# frozen_string_literal: true

# == Schema Information
#
# Table name: test_case_results
#
#  id            :bigint           not null, primary key
#  is_passed     :boolean
#  submission_id :bigint           not null
#  test_case_id  :bigint           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  output        :string
#
class TestCaseResult < ApplicationRecord
  belongs_to :submission
  belongs_to :test_case
end
