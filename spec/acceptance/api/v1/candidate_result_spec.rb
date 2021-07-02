# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'CandidateResult' do
  get '/api/v1/drives/:drife_id/problems/:problem_id/candidate_results/:id' do
    parameter :id, 'Candidate id'
    parameter :drife_id, 'Drive id'
    parameter :problem_id, 'Problem id'
    let!(:organization) { create(:organization) }
    let!(:user) { create(:user) }
    let!(:problem) do
      create(:problem, updated_by_id: user.id, created_by_id: user.id,
                       organization: organization)
    end

    let!(:drive) do
      create(:drive, updated_by_id: user.id, created_by_id: user.id,
                     organization: organization)
    end

    let!(:candidate) { create(:candidate) }
    let!(:drives_candidate) { create(:drives_candidate, drive_id: drive.id, candidate_id: candidate.id, drive_start_time: DateTime.current, drive_end_time: DateTime.current + 1.hours) }
    let!(:test_case) do
      create(:test_case, problem_id: problem.id, input: 'hello', output: 'hello', marks: 4, updated_by_id: user.id,
                         created_by_id: user.id)
    end
    let!(:submission) { create(:submission, problem_id: problem.id, drives_candidate_id: drives_candidate.id) }
    let!(:test_case_result) do
      create(:test_case_result, test_case_id: test_case.id, submission_id: submission.id,
                                is_passed: true)
    end
    let!(:candidate_id) { candidate.id }
    let!(:drife_id) { drive.id }
    let!(:problem_id) { problem.id }
    let!(:id) { candidate.id }
    example 'API which returns passed, failed testcases and code of a candidate' do
      do_request
      response = JSON.parse(response_body)
      expect(response['data']['passed'][0]['input']).to eq('hello')
      expect(response['data']['passed'][0]['output']).to eq('hello')
      expect(response['data']['passed'][0]['marks']).to eq(4)
      expect(response['data']['failed'][0]).to eq(nil)
    end
  end
end
