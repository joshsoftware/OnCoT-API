# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Admin::UsersController, type: :controller do
  let(:user) { create(:user) }

  describe 'POST #create' do
    context 'When user is logged in' do
      before do
        auth_tokens_for_user(user)
      end
      it 'creates a user' do
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

  describe 'PUT #update' do
    context 'When user is logged in' do
      before do
        auth_tokens_for_user(user)
      end
      it 'updates the particular user details' do
        admin = create(:admin, id: 10)
        params = {
          id: admin.id,
          first_name: Faker::Name.name
        }
        expect do
          put :update, params: params
        end.to change { admin.reload.first_name }.from(admin.first_name).to(params[:first_name])
        expect(response).to have_http_status(:success)
      end

      it 'raises error exception if particular user is not found' do
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
        admin = create(:admin, id: 10)
        put :update, params: { id: admin.id, first_name: Faker::Name.first_name }

        parsed_json_data = json

        expect(parsed_json_data['errors'].first).to eq('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(401)
      end
    end
  end
end
