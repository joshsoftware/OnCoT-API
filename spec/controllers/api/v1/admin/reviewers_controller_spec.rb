# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Admin::ReviewersController, type: :controller do
  let(:user) { create(:user) }

  describe 'POST #create' do
    context 'When user is logged in' do
      before do
        auth_tokens_for_user(user)
      end
      it 'creates a reviewer' do
        @request.env['devise.mapping'] = Devise.mappings[:user]

        organization = create(:organization)
        role = create(:role, name: 'Reviewer')
        expect do
          post :create, params: { first_name: Faker::Name.name, last_name: Faker::Name.name, email: Faker::Internet.email,
                                  organization_id: organization.id, role_id: role.id, password: 'josh123' }
        end.to change { User.count }.to(2).from(1)
        expect(response).to have_http_status(:created)
      end
    end
    context 'When user is not logged in' do
      it ' ask for login ' do
        organization = create(:organization)
        role = create(:role)
        post :create, params: { first_name: Faker::Name.name, last_name: Faker::Name.name, email: Faker::Internet.email,
                                organization_id: organization.id, role_id: role.id, password: 'josh123' }

        parsed_json_data = json

        expect(parsed_json_data['errors'].first).to eq('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'GET #index' do
    context 'When user is logged in' do
      before do
        auth_tokens_for_user(user)
      end
      it 'returns all reviewers details' do
        reviewer = create(:reviewer, organization_id: 1)
        get :index, params: { organization_id: reviewer.organization_id }

        parsed_json_data = json

        expect(parsed_json_data['data']['reviewers'][0]['first_name']).to eq(reviewer.first_name)
        expect(parsed_json_data['data']['reviewers'].count).to eq(1)
        expect(response).to have_http_status(:ok)
      end
    end
    context 'When user is not logged in' do
      it ' ask for login ' do
        get :index

        parsed_json_data = json

        expect(parsed_json_data['errors'].first).to eq('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'PUT #update' do
    context 'When user is logged in' do
      before do
        auth_tokens_for_user(user)
      end
      it 'updates the particular reviewer details' do
        reviewer = create(:reviewer, id: 10)
        params = {
          id: reviewer.id,
          first_name: Faker::Name.name
        }
        expect do
          put :update, params: params
        end.to change { reviewer.reload.first_name }.from(reviewer.first_name).to(params[:first_name])
        expect(response).to have_http_status(:success)
      end

      it 'raises error exception if particular reviewer is not found' do
        params = {
          id: 0,
          first_name: Faker::Name.name
        }
        put :update, params: params

        expect(response).to have_http_status(:not_found)
      end
    end
    context 'When user is not logged in' do
      it ' ask for login ' do
        reviewer = create(:reviewer, id: 10)
        put :update, params: { id: reviewer.id, first_name: Faker::Name.first_name }

        parsed_json_data = json

        expect(parsed_json_data['errors'].first).to eq('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'GET #show' do
    context 'When user is logged in' do
      before do
        auth_tokens_for_user(user)
      end
      it 'displays the particular reviewer details' do
        reviewer = create(:reviewer)
        get :show, params: { id: reviewer.id }

        parsed_json_data = json
        expect(parsed_json_data['data']['reviewer']['first_name']).to eq(reviewer[:first_name])
        expect(response).to have_http_status(:ok)
      end

      it 'raises error exception if particular reviewer is not found' do
        get :show, params: { id: Faker::Number }

        expect(response).to have_http_status(:not_found)
      end
    end
    context 'When user is not logged in' do
      it ' ask for login ' do
        reviewer = create(:reviewer)
        get :show, params: { id: reviewer.id }

        parsed_json_data = json

        expect(parsed_json_data['errors'].first).to eq('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(401)
      end
    end
  end
end
