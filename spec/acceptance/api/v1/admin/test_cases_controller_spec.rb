# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'TestCase' do
  let!(:organization) { create(:organization) }
  let!(:role) { create(:role) }
  let!(:user) { create(:user) }
  let!(:problem) do
    create(:problem, created_by_id: user.id,
                     updated_by_id: user.id, organization: organization)
  end
  let!(:test_case) do
    create(:test_case, problem_id: problem.id, created_by_id: user.id,
                       updated_by_id: user.id)
  end
  let!(:auth_token) { user.create_new_auth_token }

  get '/api/v1/admin/problem/:problem_id/test_cases' do
    context 'When user is logged in' do
      parameter :problem_id, 'Problem id'
      let!(:problem_id) { problem.id }
      example 'shows all test_cases' do
        header 'access-token', auth_token['access-token']
        header 'client', auth_token['client']
        header 'uid', auth_token['uid']
        do_request
        response = JSON.parse(response_body)
        expect(response['data']['test_cases'].count).to eq(1)
        expect(status).to eq(200)
      end
    end
    context 'When user is not logged in' do
      parameter :problem_id, 'Problem id'
      let!(:problem_id) { problem.id }
      example 'Unauthorized user - ask for login ' do
        do_request
        response = JSON.parse(response_body)
        expect(response['errors'].first).to eq('You need to sign in or sign up before continuing.')
        expect(status).to eq(401)
      end
    end
  end

  get '/api/v1/admin/test_cases/:id' do
    context 'When user is logged in' do
      context 'with valid params' do
        parameter :id, 'TestCase id'
        let!(:id) { test_case.id }
        example 'shows a test_case' do
          header 'access-token', auth_token['access-token']
          header 'client', auth_token['client']
          header 'uid', auth_token['uid']
          do_request
          response = JSON.parse(response_body)
          expect(response['data']['test_case']['input']).to eq(test_case.input)
          expect(status).to eq(200)
        end
      end

      context 'with invalid params' do
        parameter :id, 'TestCase id'
        let!(:id) { Faker::Number.number }
        example 'returns the not found error as passing random id which is not present in database' do
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

  post '/api/v1/admin/test_cases' do
    context 'with valid params' do
      parameter :input, 'TestCase input'
      parameter :output, 'TestCase output'
      parameter :marks, 'TestCase marks'
      parameter :created_by_id, 'user id'
      parameter :updated_by_id, 'user id'
      parameter :problem_id, 'Problem id'
      let!(:input) { Faker::Number.digit }
      let!(:output) { Faker::Number.digit }
      let!(:marks) { Faker::Number.digit }
      let!(:created_by_id) { user.id }
      let!(:updated_by_id) { user.id }
      let!(:problem_id) { problem.id }
      example 'test case create API' do
        header 'access-token', auth_token['access-token']
        header 'client', auth_token['client']
        header 'uid', auth_token['uid']
        do_request
        response = JSON.parse(response_body)
        expect(response['data']['test_case']['input'].to_i).to eq(input)
        expect(status).to eq(200)
      end
    end

    context 'with invalid params' do
      parameter :input, 'TestCase input'
      parameter :output, 'TestCase output'
      parameter :marks, 'TestCase marks'
      parameter :created_by_id, 'user id'
      parameter :updated_by_id, 'user id'
      let!(:input) { Faker::Number.digit }
      let!(:output) { Faker::Number.digit }
      let!(:marks) { Faker::Number.digit }
      let!(:created_by_id) { user.id }
      let!(:updated_by_id) { user.id }
      example 'fails to create test case without problem id' do
        header 'access-token', auth_token['access-token']
        header 'client', auth_token['client']
        header 'uid', auth_token['uid']
        do_request
        response = JSON.parse(response_body)
        expect(response['problem'][0]).to eq('must exist')
        expect(status).to eq(400)
      end
    end
  end

  put '/api/v1/admin/test_cases/:id' do
    context 'When user is logged in' do
      context 'with valid params' do
        parameter :id, 'TestCase id'
        parameter :input, 'TestCase input'
        parameter :output, 'TestCase output'
        parameter :marks, 'TestCase marks'
        parameter :created_by_id, 'user id'
        parameter :updated_by_id, 'user id'
        parameter :problem_id, 'Problem id'
        let!(:id) { test_case.id }
        let!(:input) { '201' }
        let!(:output) { Faker::Number.digit }
        let!(:marks) { Faker::Number.digit }
        let!(:created_by_id) { user.id }
        let!(:updated_by_id) { user.id }
        let!(:problem_id) { problem.id }
        example 'TestCase update API' do
          header 'access-token', auth_token['access-token']
          header 'client', auth_token['client']
          header 'uid', auth_token['uid']
          do_request
          expect(test_case.reload.input).to eq('201')
          expect(status).to eq(200)
        end
      end

      context 'with invalid params' do
        parameter :id, 'TestCase id'
        let!(:id) { Faker::Number.number }
        example 'fails to update test case with random id' do
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
end
