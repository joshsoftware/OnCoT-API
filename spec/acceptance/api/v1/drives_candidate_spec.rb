# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'DrivesCandidate' do
  let!(:organization) { create(:organization) }
  let!(:user) { create(:user) }
  let!(:candidate) { create(:candidate) }
  let!(:candidate1) { create(:candidate) }
  let!(:candidate2) { create(:candidate) }
  let!(:drive) do
    create(:drive, updated_by_id: user.id, organization: organization,
                   created_by_id: user.id)
  end
  let!(:drives_candidate) { create(:drives_candidate, candidate_id: candidate.id, drive_id: drive.id, drive_start_time: DateTime.current, drive_end_time: DateTime.current + 1.hours) }
  let!(:drives_candidate1) { create(:drives_candidate, candidate_id: candidate1.id, drive_id: drive.id, drive_start_time: DateTime.current, drive_end_time: DateTime.current + 1.hours) }
  let!(:drives_candidate2) { create(:drives_candidate, candidate_id: candidate2.id, drive_id: drive.id, drive_start_time: DateTime.current, drive_end_time: DateTime.current + 1.hours) }
  let!(:problem) { create(:problem, updated_by_id: user.id, created_by_id: user.id) }
  let!(:submission1) do
    create(:submission, drives_candidate_id: drives_candidate1.id, problem_id: problem.id,
                        answer: 'puts "submission 1"')
  end
  let!(:submission2) do
    create(:submission, drives_candidate_id: drives_candidate2.id, problem_id: problem.id,
                        answer: 'puts "submission 2"', total_marks: 10)
  end
  let!(:submission3) do
    create(:submission, drives_candidate_id: drives_candidate2.id, problem_id: problem.id,
                        answer: 'puts "submission 3"', total_marks: 20)
  end
  patch '/api/v1/drives_candidates/:id' do
    parameter :id, 'Candidate id'
    parameter :drive_id, 'Drive id'
    context 'with valid params' do
      let!(:id) { candidate.id }
      let!(:drive_id) { drive.id }
      example 'completed_at field update API' do
        do_request
        response = JSON.parse(response_body)
        expect(response['data']).to eq(drives_candidate.reload.completed_at.iso8601.to_s)
        expect(response['message']).to eq(I18n.t('success.message'))
      end
    end

    context 'with invalid params' do
      let!(:id) { Faker::Number.number }
      let!(:drive_id) { Faker::Number.number }
      example 'fails to update completed at field' do
        do_request
        expect(response_body).to eq(I18n.t('not_found.message'))
      end
    end
  end

  get '/api/v1/drives_candidates/:drives_candidate_id/show_code' do
    parameter :drives_candidate_id, 'DrivesCandidate id'
    context 'candidate with zero submission' do
      let!(:drives_candidate_id) { drives_candidate.id }
      example 'no submission found API' do
        do_request
        expect(response_body).to eq(I18n.t('not_found.message'))
      end
    end

    context 'candidate with one submission' do
      let!(:drives_candidate_id) { drives_candidate1.id }
      example 'API to return submitted code' do
        do_request
        response = JSON.parse(response_body)
        expect(response['data']['answer']).to eq(submission1.answer)
        expect(response['message']).to eq(I18n.t('success.message'))
      end
    end

    context 'candidate with multiple submission' do
      let!(:drives_candidate_id) { drives_candidate2.id }
      example 'API to return submission with maximum marks' do
        do_request
        response = JSON.parse(response_body)
        expect(response['data']['answer']).to eq(submission3.answer)
        expect(response['data']['total_marks']).to eq(submission3.total_marks)
        expect(response['message']).to eq(I18n.t('success.message'))
      end
    end

    context 'with invalid params' do
      let!(:drives_candidate_id) { Faker::Number.number }
      example 'DrivesCandidate not found' do
        do_request
        expect(response_body).to eq(I18n.t('not_found.message'))
      end
    end
  end
end
