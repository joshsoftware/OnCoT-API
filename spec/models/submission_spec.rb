# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Submission do
  before do
    organization = create(:organization)
    user = create(:user)
    candidate1 = create(:candidate)
    candidate2 = create(:candidate)
    @drive1 = create(:drive, updated_by_id: user.id, created_by_id: user.id,
                             organization: organization)
    drives_candidate1 = create(:drives_candidate, drive_id: @drive1.id, candidate_id: candidate1.id,
                                                  completed_at: Time.now.iso8601)
    drives_candidate2 = create(:drives_candidate, drive_id: @drive1.id, candidate_id: candidate2.id,
                                                  end_time: Time.now.iso8601)
    problem1 = create(:problem, updated_by_id: user.id, created_by_id: user.id,
                                organization: organization)
    create(:drives_problem, problem_id: problem1.id, drive_id: @drive1.id)
    test_case1 = create(:test_case, problem_id: problem1.id, marks: 4, updated_by_id: user.id,
                                    created_by_id: user.id)
    test_case2 = create(:test_case, problem_id: problem1.id, marks: 5, updated_by_id: user.id,
                                    created_by_id: user.id)
    submission1 = create(:submission, problem_id: problem1.id, drives_candidate_id: drives_candidate1.id)

    submission2 = create(:submission, problem_id: problem1.id, drives_candidate_id: drives_candidate2.id)

    create(:test_case_result, test_case_id: test_case1.id, submission_id: submission1.id,
                              is_passed: true)
    create(:test_case_result, test_case_id: test_case2.id, submission_id: submission1.id,
                              is_passed: false)
    create(:test_case_result, test_case_id: test_case1.id, submission_id: submission2.id,
                              is_passed: true)
    create(:test_case_result, test_case_id: test_case2.id, submission_id: submission2.id,
                              is_passed: true)
  end
end
