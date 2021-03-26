# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Admin::DrivesController, type: :controller do
  let(:organization) { create(:organization) }
  let(:role) { create(:role) }
  let(:user) { create(:user) }
  let(:drive) { create(:drive, created_by_id: user.id, updated_by_id: user.id, organization: organization) }
  describe 'GET#index' do
    context 'when user is logged in' do
      before do
        auth_tokens_for_user(user)
      end
      it 'returns all drives' do
        get :index, params: { drive_id: drive.id }

        data = json
        expect(data['data']['drives'].count).to eq(Drive.count)
        expect(response).to have_http_status(:ok)
      end
    end
    context 'When user is not logged in' do
      it ' ask for login ' do
        get :index, params: { drive_id: drive.id }

        data = json

        expect(data['errors'].first).to eq('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'action#create' do
    context 'when user is logged in' do
      before do
        auth_tokens_for_user(user)
      end
      context 'with valid params' do
        it 'creates a drive' do
          expect do
            post :create, params: {
              name: Faker::Name.name, organization_id: organization.id, created_by_id: user.id, updated_by_id: user.id
            }
          end.to change { Drive.count }.to(1).from(0)
          expect(response).to have_http_status(:ok)
        end
      end
    end

    context 'When user is not logged in' do
      it ' ask for login ' do
        post :create, params: {
          name: Faker::Name.name, organization_id: organization.id, created_by_id: user.id, updated_by_id: user.id
        }
        data = json

        expect(data['errors'].first).to eq('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'action#update' do
    context 'when user is logged in' do
      before do
        auth_tokens_for_user(user)
      end
      context 'with valid params' do
        it 'updates the particular drive details' do
          params = {
            id: drive.id, name: Faker::Name.name, organization_id: organization.id, created_by_id: user.id,
            updated_by_id: user.id
          }
          expect do
            put :update, params: params
          end.to change { drive.reload.name }.from(drive.name).to(params[:name])
          expect(response).to have_http_status(:success)
        end
      end
      context 'with invalid params' do
        it 'returns the not found error as passing random id which is not present in database' do
          patch :update, params: { id: Faker::Number }

          expect(response.body).to eq('Record Not found')
          expect(response).to have_http_status(404)
        end
      end
    end
    context 'When user is not logged in' do
      it ' ask for login ' do
        patch :update, params: {
          id: Faker::Number, name: Faker::Name.name, organization_id: organization.id, created_by_id: user.id, updated_by_id: user.id
        }
        data = json

        expect(data['errors'].first).to eq('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'GET#show' do
    context 'when user is logged in' do
      before do
        auth_tokens_for_user(user)
      end
      context 'with valid params' do
        it 'shows details of particular drive' do
          get :show, params: { id: drive.id }

          data = json
          expect(data['data']['drive']['name']).to eq(drive.name)
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with invalid params' do
        it 'returns the not found error as passing random id which is not present in database' do
          get :show, params: { id: Faker::Number }

          expect(response.body).to eq('Record Not found')
          expect(response).to have_http_status(404)
        end
      end
    end
    context 'When user is not logged in' do
      it ' ask for login ' do
        get :show, params: { id: drive.id }

        data = json
        expect(data['errors'].first).to eq('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(401)
      end
    end
  end
end
