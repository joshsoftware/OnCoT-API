# frozen_string_literal: true

require 'rails_helper'
require 'json'

RSpec.describe Api::V1::Admin::ReviewersController, type: :controller do
  describe 'index' do
    it 'returns all reviewers details' do
      reviewer = create(:reviewer)
      get :index
      parsed_json_data = json(response)
      expect(parsed_json_data['data']['users'][0]['first_name']).to eq(reviewer.first_name)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'create' do
    it 'creates a reviewer' do
      organization = create(:organization)
      role = create(:role)
      expect do
        post :create, params: {
          first_name: Faker::Name.name,
          last_name: Faker::Name.name,
          email: Faker::Internet.email,
          organization_id: organization.id,
          role_id: role.id,
          password: 'josh123'
        }
      end.to change { User.count }.to(1).from(0)
      expect(response).to have_http_status(:created)
    end
  end

  describe 'update' do
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
  end

  describe 'show' do
    it 'displays the particular reviewer details' do
      reviewer = create(:reviewer)
      get :show, params: { id: reviewer.id }
      # parsed_json_data = JSON.parse(response.body)
      parsed_json_data = json(response)
      expect(parsed_json_data['data']['user']['first_name']).to eq(reviewer[:first_name])
      expect(response).to have_http_status(:ok)
    end
  end
end
