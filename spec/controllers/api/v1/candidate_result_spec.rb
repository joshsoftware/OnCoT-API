# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::CandidateResultsController, type: :controller do
  # let(:organization) { create(:organization) }
  # let(:user) { create(:user) }
  # let(:problem) do
  #   create(:problem, updated_by_id: user.id, created_by_id: user.id,
  #                    organization: organization)
  # end
  # let(:drive) do
  #   create(:drive, updated_by_id: user.id, created_by_id: user.id,
  #                  organization: organization)
  # end
  # let(:candidate) { create(:candidate) }
  # let(:drives_candidate) { create(:drives_candidate, drive_id: drive.id, candidate_id: candidate.id) }
  # let(:test_case) do
  #   create(:test_case, problem_id: problem.id, marks: 4, updated_by_id: user.id,
  #                      created_by_id: user.id)
  # end
  # # create(:drives_problem, problem_id: problem.id, drive_id: drive.id)
  # let(:submission) { create(:submission, problem_id: problem.id, drives_candidate_id: drives_candidate.id) }
  # let(:test_case_result) do
  #   create(:test_case_result, test_case_id: test_case.id, submission_id: submission.id,
  #                             is_passed: true)
  # end

  describe 'GET #show' do
    before do
      organization = create(:organization)
      user = create(:user)
      @problem =
        create(:problem, updated_by_id: user.id, created_by_id: user.id,
                         organization: organization)

      @drive =
        create(:drive, updated_by_id: user.id, created_by_id: user.id,
                       organization: organization)

      @candidate = create(:candidate)
      drives_candidate = create(:drives_candidate, drive_id: @drive.id, candidate_id: @candidate.id)
      @test_case =
        create(:test_case, problem_id: @problem.id, input: 'hello', output: 'hello', marks: 4, updated_by_id: user.id,
                           created_by_id: user.id)
      submission = create(:submission, problem_id: @problem.id, drives_candidate_id: drives_candidate.id)
      create(:test_case_result, test_case_id: @test_case.id, submission_id: submission.id,
                                is_passed: true)
    end
    it 'returns passed, failed testcases' do
      get :show, params: { id: @candidate.id, drife_id: @drive.id, problem_id: @problem.id }

      result = json
      expect(result['data']['passed'][0]['id']).to eq(6)
      expect(result['data']['passed'][0]['input']).to eq('hello')
      expect(result['data']['passed'][0]['output']).to eq('hello')
      expect(result['data']['passed'][0]['marks']).to eq(4)
      expect(result['data']['failed'][0]).to eq(nil)
    end
  end
end
