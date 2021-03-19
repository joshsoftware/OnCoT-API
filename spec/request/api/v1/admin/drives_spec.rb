require 'rails_helper'

RSpec.describe Api::V1::Admin::DrivesController, type: :controller do
  # let(:organization) { create(:organization) }
  describe 'GET index' do
    it 'shows all drives' do
      get :index

      data = json
      expect(data['data']['drives'].count).to eq(Drive.count)
      expect(response).to have_http_status(:ok)
    end
  end
  describe 'create' do
    it 'creates a drive' do
      organization = create(:organization)
      user = create(:user)
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
  end
  describe 'update' do
    it 'updates the particular drive details' do
      user = create(:user)
      organization = create(:organization)
      drive = create(:drive, id: 1, created_by_id: user.id, updated_by_id: user.id)
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
  end
end
