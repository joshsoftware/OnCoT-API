# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'
require 'json'

RSpec.describe CandidatesController, type: :controller do
  before :each do
    admin = create(:admin)
    @drive = create(:drive, created_by_id: admin.id, updated_by_id: admin.id, organization_id: admin.organization_id)
    @candidate = create(:candidate)
  end

  describe 'PUT update' do
    it 'updates the particular candidate details' do
      params = {
        id: @candidate.id,
        drife_id: @drive.id,
        first_name: Faker::Name.name
      }
      expect do
        put :update, params: params
      end.to change { @candidate.reload.first_name }.from(@candidate.first_name).to(params[:first_name])
      expect(response).to have_http_status(:success)
    end

    it 'raises error exception if particular candidate is not found' do
      params = {
        id: 0,
        first_name: Faker::Name.name
      }
      put :update, params: params

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'GET candidate_test_time_left' do
    it 'returns the time remaining for a candidate if test is in progress' do
      params = {
        drife_id: @drive.id,
        candidate_id: @candidate.id
      }
      get :candidate_test_time_left, params: params

      parsed_json_data = json(response)
      expect(parsed_json_data['data']['time_left']).to be.positive?
      expect(response).to have_http_status(:ok)
    end

    it 'test had already completed' do
      params = {
        drife_id: @drive.id,
        candidate_id: @candidate.id
      }
      get :candidate_test_time_left, params: params

      travel 4.hours
      expect(@drive.end_time - DateTime.now.localtime).to be.negative?
      expect(response).to have_http_status(:ok)
    end
  end
end
