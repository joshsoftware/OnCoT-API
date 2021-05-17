# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Reviewer' do
  header 'Accept', 'application/json'
  let(:user) { create(:user) }
  let!(:auth_token) { user.create_new_auth_token }
  let!(:organization) { create(:organization) }
  get '/api/v1/admin/reviewers' do
    context 'When user is logged in' do
      parameter :organization_id, 'reviewer\'s organization id'
      let!(:reviewer) { create(:reviewer, organization_id: organization.id) }
      let!(:organization_id) { reviewer.organization_id }
      example 'returns all reviewers details' do
        header 'access-token', auth_token['access-token']
        header 'client', auth_token['client']
        header 'uid', auth_token['uid']
        do_request
        response = JSON.parse(response_body)
        expect(response['data']['reviewers'][0]['first_name']).to eq(reviewer.first_name)
        expect(response['data']['reviewers'].count).to eq(1)
        expect(response['message']).to eq('Reviewer list displayed successfully.')
        expect(status).to eq(200)
      end
    end
    context 'When user is not logged in' do
      example 'Unautorized - ask for login ' do
        do_request
        response = JSON.parse(response_body)
        expect(response['errors'].first).to eq('You need to sign in or sign up before continuing.')
        expect(status).to eq(401)
      end
    end
  end

  post '/api/v1/admin/reviewers' do
    parameter :first_name, 'First name'
    parameter :last_name, 'Last name'
    parameter :email, 'Email'
    parameter :password, 'Password'
    parameter :organization_id, 'Organization id'
    parameter :role_id, 'Role id'
    let!(:role) { create(:role, name: 'Reviewer') }
    let!(:organization) { create(:organization) }
    let!(:first_name) { Faker::Name.name }
    let!(:last_name) { Faker::Name.name }
    let!(:email) { Faker::Internet.email }
    let!(:organization_id) { organization.id }
    let!(:role_id) { role.id }
    let!(:password) { 'josh123' }
    example 'reviewer create API' do
      header 'access-token', auth_token['access-token']
      header 'client', auth_token['client']
      header 'uid', auth_token['uid']
      do_request
      expect(User.count).to eq(2)
      expect(status).to eq(201)
    end
  end

  get '/api/v1/admin/reviewers/:id' do
    context 'with valid params' do
      let!(:reviewer) { create(:reviewer) }
      let!(:id) { reviewer.id }
      example 'displays the particular reviewer details' do
        header 'access-token', auth_token['access-token']
        header 'client', auth_token['client']
        header 'uid', auth_token['uid']
        do_request
        response = JSON.parse(response_body)
        expect(response['data']['reviewer']['first_name']).to eq(reviewer[:first_name])
        expect(status).to eq(200)
      end
    end

    context 'with invalid params' do
      let!(:id) { Faker::Number.number }
      example 'raises error exception if particular reviewer is not found' do
        header 'access-token', auth_token['access-token']
        header 'client', auth_token['client']
        header 'uid', auth_token['uid']
        do_request
        expect(status).to eq(404)
      end
    end
  end

  put '/api/v1/admin/reviewers/:id' do
    context 'with valid params' do
      parameter :id, 'Reviewer id'
      parameter :first_name, 'First name'
      let!(:reviewer) { create(:reviewer) }
      let!(:id) { reviewer.id }
      let!(:first_name) { Faker::Name.name }
      example 'updates the particular reviewer details' do
        header 'access-token', auth_token['access-token']
        header 'client', auth_token['client']
        header 'uid', auth_token['uid']
        do_request
        expect(reviewer.reload.first_name).to eq(first_name)
        expect(status).to eq(200)
      end
    end

    context 'with invalid params' do
      parameter :id, 'Reviewer id'
      parameter :first_name, 'First name'
      let!(:id) { Faker::Number.number }
      let!(:first_name) { Faker::Name.name }
      example 'raises error exception if particular reviewer is not found' do
        header 'access-token', auth_token['access-token']
        header 'client', auth_token['client']
        header 'uid', auth_token['uid']
        do_request
        expect(status).to eq(404)
      end
    end
  end
end
