require 'rails_helper'
require 'json'

RSpec.describe Api::V1::Admin::ReviewersController, type: :controller do
  describe 'index' do
    it 'returns all reviewers details' do
      created_reviewer = create(:reviewer)
      get :index
      parsed_json_data = JSON.parse(response.body)
      expect(parsed_json_data['data']['users'][0]['first_name']).to eq(created_reviewer.first_name)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'create' do
    it 'creates a reviewer' do
      organization = create(:organization)
      role = create(:role)
      params = {
        first_name: Faker::Name.name,
        last_name: Faker::Name.name,
        email: Faker::Internet.email,
        organization_id: organization.id,
        role_id: role.id,
        password: 'josh123'
      }
      post :create, params: params
      parsed_json_data = JSON.parse(response.body)
      expect(parsed_json_data['data']['user']['first_name']).to eq(params[:first_name])
      expect(response).to have_http_status(201)
    end
  end

  describe 'update' do
    it 'updates the particular reviewer details' do
      created_reviewer = create(:reviewer)
      params_to_be_updated = {
        id: created_reviewer.id,
        first_name: 'Neha update'
      }
      put :update, params: params_to_be_updated
      parsed_json_data = JSON.parse(response.body)
      expect(parsed_json_data['data']['user']['first_name']).to eq(params_to_be_updated[:first_name])
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'show' do
    it 'displays the particular reviewer details' do
      created_reviewer = create(:reviewer)
      get :show, params: { id: created_reviewer.id }
      parsed_json_data = JSON.parse(response.body)
      expect(parsed_json_data['data']['user']['first_name']).to eq(created_reviewer[:first_name])
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'destroy' do
    it 'destorys the particular reviewer details' do
      created_reviewer = create(:reviewer)
      delete :destroy, params: { id: created_reviewer.id }
      parsed_json_data = JSON.parse(response.body)
      expect(parsed_json_data['data']['user']['first_name']).to eq(created_reviewer[:first_name])
      expect(response).to have_http_status(:ok)
    end
  end
end
