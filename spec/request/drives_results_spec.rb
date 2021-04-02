# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DrivesResultsController, type: :controller do
  describe 'GET show' do
    before(:each) do
      organization = create(:organization)
      user = create(:user)
      candidate1 = create(:candidate)
      candidate2 = create(:candidate)
      @drive = create(:drive, updated_by_id: user.id, created_by_id: user.id,
                              organization: organization)
      @drives_candidate1 = create(:drives_candidate, drive_id: @drive.id, candidate_id: candidate1.id,
                                                     completed_at: Time.now.iso8601)
      @drives_candidate2 = create(:drives_candidate, drive_id: @drive.id, candidate_id: candidate2.id,
                                                     end_time: Time.now.iso8601)
      @problem = create(:problem, updated_by_id: user.id, created_by_id: user.id,
                                  organization: organization)
      test_case1 = create(:test_case, problem_id: @problem.id, marks: 4, updated_by_id: user.id,
                                      created_by_id: user.id)
      test_case2 = create(:test_case, problem_id: @problem.id, marks: 5, updated_by_id: user.id,
                                      created_by_id: user.id)
      submission1 = create(:submission, problem_id: @problem.id, candidate_id: candidate1.id)
      submission2 = create(:submission, problem_id: @problem.id, candidate_id: candidate1.id)
      submission3 = create(:submission, problem_id: @problem.id, candidate_id: candidate2.id)
      submission4 = create(:submission, problem_id: @problem.id, candidate_id: candidate2.id)
      create(:test_case_result, test_case_id: test_case1.id, submission_id: submission1.id,
                                is_passed: true)
      create(:test_case_result, test_case_id: test_case2.id, submission_id: submission1.id,
                                is_passed: true)
      create(:test_case_result, test_case_id: test_case1.id, submission_id: submission2.id,
                                is_passed: true)
      create(:test_case_result, test_case_id: test_case2.id, submission_id: submission2.id,
                                is_passed: false)
      create(:test_case_result, test_case_id: test_case1.id, submission_id: submission3.id,
                                is_passed: false)
      create(:test_case_result, test_case_id: test_case2.id, submission_id: submission3.id,
                                is_passed: true)
      create(:test_case_result, test_case_id: test_case1.id, submission_id: submission4.id,
                                is_passed: true)
      create(:test_case_result, test_case_id: test_case2.id, submission_id: submission4.id,
                                is_passed: false)
    end
    context 'with valid params' do
      it 'returns drives arrays of candidate_id, scores, end_times' do
        get :show, params: { problem_id: @problem.id, id: @drive.id }

        result = json
        expect(result['data']['candidate_id']).to eq([1, 2])
        expect(result['data']['score']).to eq([9, 5])
        expect(result['data']['end_time']).to eq([@drives_candidate1.reload.completed_at.iso8601.to_s,
                                                  @drives_candidate2.reload.end_time.iso8601.to_s])
        expect(result['message']).to eq(I18n.t('success.message'))
        expect(response).to have_http_status(200)
      end
    end
  end
end
