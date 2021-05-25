# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Drive' do
  header 'Accept', 'application/json'
  let!(:organization) { create(:organization) }
  let!(:role) { create(:role) }
  let!(:user) { create(:user, role_id: role.id) }
  let!(:problem) { create(:problem, created_by_id: user.id, updated_by_id: user.id) }
  let!(:drive) { create(:drive, created_by_id: user.id, updated_by_id: user.id, organization: organization) }
  let!(:drives_problem) { create(:drives_problem, drive_id: drive.id, problem_id: problem.id) }
  let!(:candidate) { create(:candidate, first_name: 'Neha', last_name: 'Sharma', email: 'neha@gmail.com') }
  let!(:drives_candidate) { create(:drives_candidate, drive_id: drive.id, candidate_id: candidate.id) }
  let!(:auth_token) { user.create_new_auth_token }
  get '/api/v1/admin/drives' do
    context 'when user is logged in' do
      example 'get all drives' do
        header 'access-token', auth_token['access-token']
        header 'client', auth_token['client']
        header 'uid', auth_token['uid']
        do_request
        expect(status).to eq(200)
      end
      example 'Authentication fails with invalid authentication token' do
        header 'access-token', 'token123'
        header 'client', auth_token['client']
        header 'uid', auth_token['uid']
        do_request
        expect(status).to eq(401)
      end
    end
    context 'When user is not logged in' do
      example 'unauthorized user - ask for login ' do
        do_request
        response = JSON.parse(response_body)
        expect(response['errors'].first).to eq('You need to sign in or sign up before continuing.')
        expect(status).to eq(401)
      end
    end
  end
  post '/api/v1/admin/drives' do
    parameter :name, 'Drive name'
    parameter :organization_id, 'Organization id'
    parameter :created_by_id, 'User id'
    parameter :updated_by_id, 'User id'
    let!(:name) { Faker::Name.name }
    let!(:organization_id) { organization.id }
    let!(:created_by_id) { user.id }
    let!(:updated_by_id) { user.id }
    example 'Drive create API' do
      header 'access-token', auth_token['access-token']
      header 'client', auth_token['client']
      header 'uid', auth_token['uid']
      do_request
      expect(Drive.count).to eq(2)
      expect(status).to eq(200)
    end
  end

  put '/api/v1/admin/drives/:id' do
    context 'with valid params' do
      parameter :name, 'Drive name'
      parameter :organization_id, 'Organization id'
      parameter :created_by_id, 'User id'
      parameter :updated_by_id, 'User id'
      let!(:id) { drive.id }
      let!(:name) { Faker::Name.name }
      let!(:organization_id) { organization.id }
      let!(:created_by_id) { user.id }
      let!(:updated_by_id) { user.id }
      example 'Drive update API' do
        header 'access-token', auth_token['access-token']
        header 'client', auth_token['client']
        header 'uid', auth_token['uid']
        do_request
        response = JSON.parse(response_body)
        expect(response['message']).to eq('Drive updated successfully')
        expect(status).to eq(200)
      end
    end

    context 'with invalid params' do
      let!(:id) { Faker::Number.number }
      example 'Drive update fails with invalid id' do
        header 'access-token', auth_token['access-token']
        header 'client', auth_token['client']
        header 'uid', auth_token['uid']
        do_request
        expect(response_body).to eq(I18n.t('not_found.message'))
        expect(status).to eq(404)
      end
    end
  end

  get '/api/v1/admin/drives/:id' do
    context 'with valid params' do
      let!(:id) { drive.id }
      example 'shows details of particular drive' do
        header 'access-token', auth_token['access-token']
        header 'client', auth_token['client']
        header 'uid', auth_token['uid']
        do_request
        response = JSON.parse(response_body)
        expect(response['data']['drive']['name']).to eq(drive.name)
        expect(status).to eq(200)
      end
    end

    context 'with invalid params' do
      let!(:id) { Faker::Number.number }
      example 'with random id fails to show drive details' do
        header 'access-token', auth_token['access-token']
        header 'client', auth_token['client']
        header 'uid', auth_token['uid']
        do_request
        expect(response_body).to eq(I18n.t('not_found.message'))
        expect(status).to eq(404)
      end
    end
  end

  get '/api/v1/admin/drives/:id/candidate_list' do
    context 'with valid params' do
      parameter :id, 'Drive id'
      let!(:id) { drive.id }
      example 'API to show details of all candidates of a drive' do
        header 'access-token', auth_token['access-token']
        header 'client', auth_token['client']
        header 'uid', auth_token['uid']
        do_request
        response = JSON.parse(response_body)
        expect(response['data']['candidates'][0]['first_name']).to eq(candidate.first_name)
        expect(response['data']['candidates'][0]['email']).to eq(candidate.email)
        expect(response['data']['candidates'].count).to eq(1)
        expect(status).to eq(200)
      end
    end

    context 'with invalid params' do
      parameter :id, 'Drive id'
      let!(:id) { Faker::Number.number }
      example 'with random id fails to show candidates details for a drive' do
        header 'access-token', auth_token['access-token']
        header 'client', auth_token['client']
        header 'uid', auth_token['uid']
        do_request
        expect(response_body).to eq(I18n.t('not_found.message'))
        expect(status).to eq(404)
      end
    end
  end

  post '/api/v1/admin/drives/:drife_id/send_admin_email' do
    parameter :drife_id, 'Drive id'
    parameter :score, 'Cut off score'
    let!(:organization) { create(:organization) }
    let!(:user) { create(:user) }
    let!(:candidate) { create(:candidate, first_name: 'Neha', last_name: 'Sharma', email: 'neha@gmail.com') }
    let!(:drive) do
      create(:drive, updated_by_id: user.id, created_by_id: user.id,
                     organization: organization)
    end
    let!(:drives_candidate) { create(:drives_candidate, drive_id: drive.id, candidate_id: candidate.id, score: 20) }
    let!(:problem) do
      create(:problem, updated_by_id: user.id, created_by_id: user.id,
                       organization_id: organization.id, submission_count: 3)
    end
    let!(:submission1) do
      create(:submission, problem_id: problem.id, drives_candidate_id: drives_candidate.id,
                          answer: 'puts "first submission"', total_marks: 10)
    end
    let!(:submission2) do
      create(:submission, problem_id: problem.id, drives_candidate_id: drives_candidate.id,
                          answer: 'puts "second submission"', total_marks: 20)
    end
    let!(:drife_id) { drive.id }
    let!(:score) { 10 }
    example 'API to return shortlisted candidates list in csv file' do
      header 'access-token', auth_token['access-token']
      header 'client', auth_token['client']
      header 'uid', auth_token['uid']
      do_request
      filename = "driveID_ #{drife_id}_score_#{score}.csv"
      actual_row = [['First Name', 'Neha'], ['Last Name', 'Sharma'], ['Email', 'neha@gmail.com'],
                    ['code', 'puts "second submission"']]
      table = CSV.parse(File.read(filename), headers: true)
      expected_row = table.by_row[0]
      expect(expected_row).to match_array(actual_row)
      File.delete(filename)
      expect(status).to eq(204)
    end
  end
end
