# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Problem' do
  header 'Accept', 'application/json'
  let!(:organization) { create(:organization) }
  let!(:role) { create(:role) }
  let!(:user) { create(:user) }
  let!(:problem) do
    create(:problem, created_by_id: user.id,
                     updated_by_id: user.id, organization: organization)
  end
  let!(:auth_token) { user.create_new_auth_token }

  get '/api/v1/admin/problems' do
    context 'when user is logged in' do
      example 'get all problems list' do
        header 'access-token', auth_token['access-token']
        header 'client', auth_token['client']
        header 'uid', auth_token['uid']
        do_request
        response = JSON.parse(response_body)
        expect(response['data']['problems'].count).to eq(Problem.count)
        expect(status).to eq(200)
      end
    end

    context 'when user is not logged in' do
      it ' Unauthorized - ask to login' do
        do_request
        expect(response_body).to eq('{"errors":["You need to sign in or sign up before continuing."]}')
        expect(status).to eq(401)
      end
    end
  end

  get '/api/v1/admin/problems/:id' do
    context 'with valid params' do
      parameter :id, 'Problem id'
      let!(:id) { problem.id }
      example 'shows a problem with valid problem id' do
        header 'access-token', auth_token['access-token']
        header 'client', auth_token['client']
        header 'uid', auth_token['uid']
        do_request
        response = JSON.parse(response_body)
        expect(response['data']['problem']['title']).to eq(problem.title)
        expect(status).to eq(200)
      end
    end

    context 'with invalid params' do
      let!(:id) { Faker::Number.number }
      example 'returns the not found error as passing random problem id' do
        header 'access-token', auth_token['access-token']
        header 'client', auth_token['client']
        header 'uid', auth_token['uid']
        do_request
        expect(response_body).to eq(I18n.t('not_found.message'))
        expect(status).to eq(404)
      end
    end
  end

  post '/api/v1/admin/problems' do
    parameter :title, 'Problem title'
    parameter :description, 'Problem description'
    parameter :created_by_id, 'User id'
    parameter :updated_by_id, 'User id'
    parameter :organization_id, 'Organizationn id'
    let!(:title) { 'a' }
    let!(:description) { 'b' }
    let!(:created_by_id) { user.id }
    let!(:updated_by_id) { user.id }
    let!(:organization_id) { organization.id }
    example 'problem create API' do
      header 'access-token', auth_token['access-token']
      header 'client', auth_token['client']
      header 'uid', auth_token['uid']
      do_request
      response = JSON.parse(response_body)
      expect(response['data']['problem']['title']).to eq('a')
      expect(status).to eq(200)
    end
  end

  put '/api/v1/admin/problems/:id' do
    context 'with valid params' do
      parameter :id, 'Problem id'
      parameter :title, 'Problem title'
      parameter :description, 'Problem description'
      let!(:id) { problem.id }
      let!(:title) { 'b' }
      let!(:description) { Faker::Lorem.paragraph }
      example 'problem update API' do
        header 'access-token', auth_token['access-token']
        header 'client', auth_token['client']
        header 'uid', auth_token['uid']
        do_request
        response = JSON.parse(response_body)
        expect(response['message']).to eq('Problem updated successfully')
        expect(status).to eq(200)
      end
    end

    context 'with invalid params' do
      parameter :id, 'Problem id'
      let!(:id) { Faker::Number.number }
      example 'problem update fails with random id' do
        header 'access-token', auth_token['access-token']
        header 'client', auth_token['client']
        header 'uid', auth_token['uid']
        do_request
        expect(response_body).to eq(I18n.t('not_found.message'))
        expect(status).to eq(404)
      end
    end
  end
end
