# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CandidatesController, type: :controller do
  before :each do
    admin = create(:admin)
    @drive = create(:drive, created_by_id: admin.id, updated_by_id: admin.id, organization_id: admin.organization_id)
    @candidate = create(:candidate)
    @drive_candidate = create(:drives_candidate, drive_id: @drive.id, candidate_id: @candidate.id)
  end

  describe 'PUT update' do
    context 'when params are valid' do
      it 'updates the particular candidate details' do
        params = {
          id: @drive_candidate.token,
          first_name: Faker::Name.name
        }
        expect do
          put :update, params: params
        end.to change { @candidate.reload.first_name }.from(@candidate.first_name).to(params[:first_name])
        expect(response).to have_http_status(:success)
      end
    end

    context 'when particular id is not found' do
      it 'raises error exception' do
        params = {
          id: 0,
          first_name: Faker::Name.name
        }
        put :update, params: params

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'GET candidate_test_time_left' do
    context 'test is in progress' do
      it 'returns the positive time remaining as current time < end time' do
        params = {
          drife_id: @drive.id,
          candidate_id: @candidate.id
        }
        get :candidate_test_time_left, params: params

        parsed_json_data = json
        expect(parsed_json_data['data']['time_left']).to be > 0
        expect(response).to have_http_status(:ok)
      end
    end
    
    context 'test already completed' do
      it 'returns the negative time as current time > end time' do
        params = {
          drife_id: @drive.id,
          candidate_id: @candidate.id
        }
        get :candidate_test_time_left, params: params

        travel 4.hours
        expect(@drive.end_time - DateTime.now.localtime).to be < 0
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
