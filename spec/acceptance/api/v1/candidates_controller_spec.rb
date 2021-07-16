# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Candidates' do
  header 'Accept', 'application/json'
  let!(:admin) { create(:admin) }
  let!(:drive) { create(:drive, created_by_id: admin.id, updated_by_id: admin.id, organization_id: admin.organization_id, is_assessment: true) }
  let!(:candidate) { create(:candidate) }
  let!(:candidate2) { create(:candidate, id: 10) }
  let!(:drives_candidate) do
    create(:drives_candidate, drive_id: drive.id, candidate_id: candidate.id,
                              start_time: DateTime.now.localtime, end_time: DateTime.now.localtime + 1.hours, drive_start_time: DateTime.current,
                              drive_end_time: DateTime.current + 1.hours)
  end
  let!(:drives_candidate2) do
    create(:drives_candidate, drive_id: drive.id, candidate_id: candidate2.id, token: '123',
                              start_time: nil, end_time: nil, drive_start_time: DateTime.current,
                              drive_end_time: DateTime.current + 1.hours)
  end

  let!(:problem) { create(:problem, created_by_id: admin.id, updated_by_id: admin.id) }

  put '/api/v1/drives/:drife_id/candidates/:id' do
    parameter :id, 'Candidate id'
    parameter :drife_id, 'Drive id'
    parameter :first_name, 'Candidate\'s first name'
    parameter :last_name, 'Candidate\'s last name'
    parameter :email, 'Candidate\'s email'
    parameter :mobile_number, 'Candidate\'s mobile number'
    parameter :token, 'Drive Candidate\'s token'
    context 'with valid params' do
      let!(:id) { candidate.id }
      let!(:drife_id) { drive.id }
      let!(:first_name) { 'name' }
      let!(:token) { drives_candidate.token }
      example 'candidate update API' do
        do_request
        response = JSON.parse(response_body)
        expect(response['data']['candidate']['first_name']).to eq(first_name)
        expect(response['message']).to eq('Candidate updated successfully')
        expect(status).to eq(200)
      end
    end

    context 'with invalid params' do
      let!(:id) { Faker::Number.number }
      let!(:drife_id) { Faker::Number.number }
      example 'candidate not found for update' do
        do_request
        expect(status).to eq(404)
      end
    end

    context 'webhook assesmnet candidate data with valid params' do
      let!(:id) { candidate2.id }
      let!(:drife_id) { drive.id }
      let!(:token) { drives_candidate2.token }
      example 'webhook asssessment with valid params' do
        do_request
        response = JSON.parse(response_body)
        expect(response['data']['candidate']['id']).to eq(candidate2.id)
        expect(response['message']).to eq('Candidate updated successfully')
        expect(status).to eq(200)
      end
    end
  end

  get '/api/v1/candidates/:id' do
    let!(:id) { candidate.id }
    example 'get specific candidate details' do
      do_request
      expect(status).to eq(200)
    end
  end

  post '/api/v1/invite' do
    parameter :emails
    parameter :drife_id
    context 'with valid params' do
      let!(:emails) { candidate.email }
      let!(:drife_id) { drive.id }
      example 'candidate mail invite send API' do
        do_request
        expect(status).to eq(200)
      end
    end

    context 'with invalid params' do
      parameter :emails
      parameter :drife_id
      let!(:emails) { Faker::Internet.email }
      let!(:drife_id) { Faker::Number.number }
      example 'candidate not found for mail invite' do
        do_request
        expect(status).to eq(404)
      end
    end
  end

  get '/api/v1/drives/:drife_id/candidates/:candidate_id/candidate_test_time_left/:token' do
    parameter :drife_id, 'Drive id'
    parameter :candidate_id, 'Candidate id'
    parameter :token, 'Drives Candidate token'
    let!(:drife_id) { drive.id }
    let!(:candidate_id) { candidate.id }
    let!(:token) { drives_candidate.token }
    example 'candidate test time remaining API' do
      do_request
      response = JSON.parse(response_body)
      expect(status).to eq(200)
      expect(response['message']).to eq('Time Remaining')
    end

    example 'candidate test time completed API' do
      travel 4.hours
      do_request
      response = JSON.parse(response_body)
      expect(status).to eq(200)
      expect(response['message']).to eq('Test Time Over!')
    end
  end
end
