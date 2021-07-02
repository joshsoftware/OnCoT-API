# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Result' do
  get '/api/v1/drives/:drife_id/results' do
    parameter :drife_id, 'Drive id'
    let!(:organization) { create(:organization) }
    let!(:user) { create(:user) }
    let!(:candidate1) { create(:candidate, first_name: 'Kiran', last_name: 'Patil', email: 'kiran@gmail.com') }
    let!(:candidate2) { create(:candidate, first_name: 'Prashant', last_name: 'Patil', email: 'prashnat@gmail.com') }
    let!(:drive) do
      create(:drive, updated_by_id: user.id, created_by_id: user.id,
                     organization: organization)
    end
    let!(:drives_candidate1) do
      create(:drives_candidate, drive_id: drive.id, candidate_id: candidate1.id, score: 8,
                                completed_at: Time.now.iso8601, end_time: Time.now.iso8601, drive_start_time: DateTime.current, drive_end_time: DateTime.current + 1.hours)
    end
    let!(:drives_candidate2) do
      create(:drives_candidate, drive_id: drive.id, candidate_id: candidate2.id, score: 10,
                                end_time: Time.now.iso8601, drive_start_time: DateTime.current, drive_end_time: DateTime.current + 1.hours)
    end
    let!(:drife_id) { drive.id }
    example 'API to return candidate_id, scores, end_times of a drive' do
      do_request
      response = JSON.parse(response_body)
      expect(response['data']['result'][1]['candidate_id']).to eq(candidate1.id)
      expect(response['data']['result'][1]['first_name']).to eq('Kiran')
      expect(response['data']['result'][1]['last_name']).to eq('Patil')
      expect(response['data']['result'][1]['email']).to eq('kiran@gmail.com')
      expect(response['data']['result'][1]['score']).to eq(8)
      expect(response['data']['result'][1]['end_times']).to eq(drives_candidate1.completed_at.iso8601.to_s)
      expect(response['data']['result'][0]['candidate_id']).to eq(candidate2.id)
      expect(response['data']['result'][0]['score']).to eq(10)
      expect(response['message']).to eq(I18n.t('success.message'))
      expect(status).to eq(200)
    end
  end

  get '/api/v1/drives/:drife_id/results/csv_result' do
    parameter :drife_id, 'Drive id'
    parameter :problem_id, 'Problem id'
    let!(:organization) { create(:organization) }
    let!(:user) { create(:user) }

    let!(:candidate) { create(:candidate, first_name: 'Kiran', last_name: 'Patil', email: 'kiran@gmail.com') }
    let!(:drive) do
      create(:drive, updated_by_id: user.id, created_by_id: user.id,
                     organization: organization)
    end
    let!(:drives_candidate) { create(:drives_candidate, drive_id: drive.id, candidate_id: candidate.id, drive_start_time: DateTime.current, drive_end_time: DateTime.current + 1.hours) }
    let!(:problem) do
      create(:problem, updated_by_id: user.id, created_by_id: user.id,
                       organization: organization, submission_count: 3)
    end
    let!(:drives_problem) { create(:drives_problem, drive_id: drive.id, problem_id: problem.id) }
    let!(:test_case) do
      create(:test_case, problem_id: problem.id, updated_by_id: user.id, input: 'hello', output: 'hello',
                         created_by_id: user.id, is_active: true)
    end

    let!(:submission1) { create(:submission, problem_id: problem.id, drives_candidate_id: drives_candidate.id) }
    let!(:submission2) { create(:submission, problem_id: problem.id, drives_candidate_id: drives_candidate.id) }
    let!(:test_case_result1) do
      create(:test_case_result, test_case_id: test_case.id, submission_id: submission1.id,
                                is_passed: true)
    end
    let!(:test_case_result2) do
      create(:test_case_result, test_case_id: test_case.id, submission_id: submission2.id,
                                is_passed: false)
    end
    let!(:drife_id) { drive.id }
    let!(:problem_id) { problem.id }
    it 'API to return candidate result data in csv' do
      do_request
      actual_row = [['First Name', 'Kiran'], ['Last Name', 'Patil'], ['Email', 'kiran@gmail.com'],
                    ['Score', nil], ['Test case 1 actual output', nil], ['Test case 1 expected output', 'hello']]
      table = CSV.parse(File.read('result_file.csv'), headers: true)
      expected_row = table.by_row[0]
      expect([["Email", "kiran@gmail.com"], ["First Name", "Kiran"], ["Last Name", "Patil"], ["Score", nil], ["Test case 1 actual output", nil], ["Test case 1 expected output", "hello"]]).to match_array(actual_row)
      expect(status).to eq(200)
    end
  end
end
