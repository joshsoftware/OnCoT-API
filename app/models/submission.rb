# frozen_string_literal: true

class Submission < ApplicationRecord
  after_create :calculate_result
  belongs_to :drives_candidate
  belongs_to :problem
  has_many :test_case_results

  scope :get_submissions, lambda { |drives_candidate_id, problem_id|
    joins(test_case_results: [:test_case]).where(drives_candidate_id: drives_candidate_id,
                                                 problem_id: problem_id,
                                                 test_case_results: { is_passed: true }).select('submissions.id as submission_id,
                                                                                                  sum(test_cases.marks) as marks')
                                          .group('submissions.id')
  }

  private

  def calculate_result
    submits = Submission.get_submissions(drives_candidate_id, problem_id)
    final_marks = submits.map(&:marks).max
    drives_candidate.update(score: final_marks)
  end
end
