# frozen_string_literal: true

class Submission < ApplicationRecord
  after_create :calculate_result 
  belongs_to :drives_candidate
  belongs_to :problem
  has_many :test_case_results

  private

  def calculate_result()
    p_id = problem_id
    c_id = drives_candidate_id
    submits = Submission.joins(test_case_results: [:test_case]).where(drives_candidate_id: c_id, problem_id: p_id,
                                                                      test_case_results: { is_passed: true })
    submits = submits.select('submissions.id as submission_id, sum(test_cases.marks) as marks').group('submissions.id')
    final_marks = submits.map(&:marks).max
    drives_candidate.update(score: final_marks)
  end
end


