# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Submission do
  describe '#calculate_result' do
    before do
      organization = create(:organization)
      user = create(:user)
      candidate1 = create(:candidate)
      drive = create(:drive, updated_by_id: user.id, created_by_id: user.id,
                             organization: organization)
      @drives_candidate = create(:drives_candidate, drive_id: drive.id, candidate_id: candidate1.id,
                                                    completed_at: Time.now.iso8601)
      problem = create(:problem, updated_by_id: user.id, created_by_id: user.id,
                                 organization: organization)
      create(:drives_problem, problem_id: problem.id, drive_id: drive.id)
      test_case = create(:test_case, problem_id: problem.id, marks: 4, updated_by_id: user.id,
                                     created_by_id: user.id)
      @submission = create(:submission, problem_id: problem.id, drives_candidate_id: @drives_candidate.id)
      create(:test_case_result, test_case_id: test_case.id, submission_id: @submission.id,
                                is_passed: true)
    end
    it ' updates score to database' do
      @submission.run_callbacks(:create)
      expect(@drives_candidate.reload.score).to eq(4)
    end
  end
end
