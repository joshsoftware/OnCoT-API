# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Code' do
  let(:organization) { create(:organization) }
  let(:role) { create(:role) }
  let(:user) { create(:user, role_id: role.id) }
  let(:drive) do
    create(:drive, updated_by_id: user.id, created_by_id: user.id,
                   organization: organization, start_time: DateTime.current + 1.hours,
                   end_time: DateTime.current + 3.hours, duration: 10_800)
  end
  let(:candidate) { create(:candidate) }
  let(:drives_candidate) do
    create(:drives_candidate, drive_id: drive.id, candidate_id: candidate.id, drive_start_time: DateTime.current,
                              drive_end_time: DateTime.current + 1.hour)
  end
  let(:problem) { create(:problem, updated_by_id: user.id, created_by_id: user.id, organization: organization) }
  let!(:code) { create(:code, drives_candidate_id: drives_candidate.id, problem_id: problem.id) }

  get '/api/v1/codes/:token/:problem_id' do
    parameter :token, 'DrivesCandidate token'
    parameter :problem_id, 'Problem id'
    context 'with valid params' do
      let!(:token) { drives_candidate.token }
      let!(:problem_id) { problem.id }
      example 'get code related to a drives_candidate and problem' do
        do_request
        response = JSON.parse(response_body)
        expect(response['data']['code']['answer']).to eq(code.answer)
        expect(status).to eq(200)
      end
    end
    context 'with invalid params' do
      let!(:token) { Faker::Internet.uuid }
      let!(:problem_id) { problem.id }
      example ' returns not found error message' do
        do_request
        response = JSON.parse(response_body)
        expect(response['message']).to eq(I18n.t('not_found.message'))
        expect(status).to eq(200)
      end
    end
  end

  post '/api/v1/codes' do
    parameter :token, 'DrivesCandidate token'
    parameter :problem_id, 'Problem id'
    parameter :answer, 'Code answer'
    parameter :language_id, 'Code lang_code'
    context 'with valid params' do
      let!(:token) { drives_candidate.token }
      let!(:problem_id) { problem.id }
      let!(:answer) { Faker::Lorem.paragraph }
      let!(:language_id) { Faker::Number.digit }
      example 'create code for a problem and store to database' do
        do_request
        response = JSON.parse(response_body)
        expect(response['data']['code']['problem_id']).to eq(problem_id)
        expect(status).to eq(200)
        expect(Code.count).to eq(1)
      end
    end
    context 'with invalid params' do
      let!(:token) { Faker::Internet.uuid }
      let!(:problem_id) { problem.id }
      let!(:answer) { Faker::Lorem.paragraph }
      let!(:language_id) { Faker::Number.digit }
      example ' returns not found error message as token is fake' do
        do_request
        response = JSON.parse(response_body)
        expect(response['message']).to eq(I18n.t('not_found.message'))
        expect(status).to eq(200)
      end
    end
  end
end
