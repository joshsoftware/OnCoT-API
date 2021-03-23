# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Admin::DrivesController, type: :controller do
  let(:organization) { create(:organization) }
  let(:role) { create(:role) }
  let(:user) { create(:user) }
  let(:drive) { create(:drive, created_by_id: user.id, updated_by_id: user.id, organization: organization) }
  describe 'GET index' do
    it 'shows all drives' do
      get :index

      data = json(response)
      expect(data['data']['drives'].count).to eq(Drive.count)
      expect(response).to have_http_status(:ok)
    end
    it 'returns the not found error ' do
      patch :update, params: { id: Faker::Number }
      expect(response.body).to eq('Record Not found')
      expect(response).to have_http_status(404)
    end
  end
  describe 'create' do
    it 'creates a drive' do
      expect do
        post :create, params: {
          name: Faker::Name.name,
          organization_id: organization.id,
          created_by_id: user.id,
          updated_by_id: user.id
        }
      end.to change { Drive.count }.to(1).from(0)
      expect(response).to have_http_status(:ok)
    end
    it 'fails Create drive as not passing organization id' do
      post :create,
           params: { name: 'a', description: 'b', created_by_id: user.id,
                     updated_by_id: user.id }

      drive = json(response)
      expect(drive['organization'][0]).to eq('must exist')
      expect(response).to have_http_status(400)
    end
  end
  describe 'update' do
    it 'updates the particular drive details' do
      params = {
        id: drive.id,
        name: Faker::Name.name,
        organization_id: organization.id,
        created_by_id: user.id,
        updated_by_id: user.id
      }
      expect do
        put :update, params: params
      end.to change { drive.reload.name }.from(drive.name).to(params[:name])
      expect(response).to have_http_status(:success)
    end
    it 'returns the not found error as passing random id which is not present in database' do
      patch :update, params: { id: Faker::Number }
      expect(response.body).to eq('Record Not found')
      expect(response).to have_http_status(404)
    end
  end
  describe 'GET show' do
    it 'shows a drive' do
      get :show, params: { id: drive.id }

      data = json(response)
      expect(data['data']['drive']['name']).to eq(drive.name)
      expect(response).to have_http_status(:ok)
    end

    it 'returns the not found error as passing random id which is not present in database' do
      patch :update, params: { id: Faker::Number }
      expect(response.body).to eq('Record Not found')
      expect(response).to have_http_status(404)
    end
  end
end
