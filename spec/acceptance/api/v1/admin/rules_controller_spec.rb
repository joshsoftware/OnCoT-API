# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Rule' do
  header 'Accept', 'application/json'
  let!(:organization) { create(:organization) }
  let!(:role) { create(:role) }
  let!(:user) { create(:user) }
  let!(:drive) do
    create(:drive, created_by_id: user.id, updated_by_id: user.id,
                   organization: organization)
  end
  let!(:rule) { create(:rule, drive_id: drive.id) }
  let!(:auth_token) { user.create_new_auth_token }
  get '/api/v1/admin/rules' do
    context 'when user is logged in' do
      context 'with valid params' do
        parameter :drive_id, 'Drive id'
        let!(:drive_id) { drive.id }
        example 'returns all rules related to a drive' do
          header 'access-token', auth_token['access-token']
          header 'client', auth_token['client']
          header 'uid', auth_token['uid']
          do_request
          response = JSON.parse(response_body)
          rules = Rule.where(drive_id: drive.id)

          expect(response['data']['rules'].count).to eq(rules.count)
          expect(status).to eq(200)
        end
      end
      context 'with invalid params' do
        parameter :id, 'Drive id'
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
    context 'When user is not logged in' do
      parameter :id, 'Drive id'
      example 'Unauthorized user - ask for login ' do
        do_request
        response = JSON.parse(response_body)
        expect(response['errors'].first).to eq('You need to sign in or sign up before continuing.')
        expect(status).to eq(401)
      end
    end
  end

  post '/api/v1/admin/rules' do
    context 'When user is logged in' do
      context 'with valid params' do
        parameter :type_name, 'Rule type'
        parameter :description, 'Rule description'
        parameter :drive_id, 'Drive id'
        let!(:type_name) { Faker::Lorem.word }
        let!(:description) { Faker::Lorem.sentence }
        let!(:drive_id) { drive.id }
        example 'Creates the rule' do
          header 'access-token', auth_token['access-token']
          header 'client', auth_token['client']
          header 'uid', auth_token['uid']
          do_request
          response = JSON.parse(response_body)
          expect(response['data']['rule']['type_name']).to eq(type_name)
          expect(status).to eq(200)
        end
      end

      context 'with invalid params' do
        parameter :type_name, 'Rule type'
        parameter :description, 1
        parameter :drive_id, 'Drive id' 
        let!(:type_name) { Faker::Lorem.word }
        let!(:description) { Faker::Lorem.sentence }
        let!(:drive_id) { 'a' } 
        example 'fails to create as not passing drive id' do
          header 'access-token', auth_token['access-token']
          header 'client', auth_token['client']
          header 'uid', auth_token['uid']
          byebug
          do_request
          byebug
          expect(response_body).to eq(I18n.t('not_found.message'))
        end
      end
    end
  end

  put '/api/v1/admin/rules/:id' do
    context 'When user is logged in' do
      context 'with valid params' do
        parameter :id, 'Rule id'
        parameter :type_name, 'Rule type'
        parameter :description, 'Rule description'
        parameter :drive_id, 'Drive id'
        let!(:id) { rule.id }
        let!(:type_name) { 'changed rule type' }
        let!(:description) { Faker::Lorem.sentence }
        let!(:drive_id) { drive.id }
        example 'Updates the rule' do
          header 'access-token', auth_token['access-token']
          header 'client', auth_token['client']
          header 'uid', auth_token['uid']
          do_request
          expect(rule.reload.type_name).to eq('changed rule type')
          expect(status).to eq(200)
        end
      end

      context 'with invalid params' do
        parameter :id, 'Rule id'
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
end
