# frozen_string_literal: true

# == Schema Information
#
# Table name: submissions
#
#  id                  :bigint           not null, primary key
#  answer              :text
#  drives_candidate_id :bigint           not null
#  problem_id          :bigint           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  total_marks         :float            default(0.0)
#  lang_code           :integer
#  status              :string           default("processing")
#
class Submission < ApplicationRecord
  belongs_to :drives_candidate
  belongs_to :problem
  has_many :test_case_results

  # scope :submissions_with_passed_testcases, lambda { |drives_candidate_id, problem_id|
  #   joins(test_case_results: [:test_case]).where(drives_candidate_id: drives_candidate_id,
  #                                                problem_id: problem_id,
  #                                                test_case_results: { is_passed: true }).select('submissions.id as submission_id,
  #                                                                                                 sum(test_cases.marks) as marks')
  #                                         .group('submissions.id')
  # }
end
