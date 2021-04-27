# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::CandidatesController, type: :controller do
  before :each do
    admin = create(:admin)
    @drive = create(:drive, created_by_id: admin.id, updated_by_id: admin.id, organization_id: admin.organization_id)
    @candidate = create(:candidate)
    @drives_candidate = create(:drives_candidate, drive_id: @drive.id, candidate_id: @candidate.id,
                                                  start_time: DateTime.now.localtime, end_time: DateTime.now.localtime + 1.hours)
    problem = create(:problem, created_by_id: admin.id, updated_by_id: admin.id)
    DrivesProblem.create(drive_id: @drive.id, problem_id: problem.id)
  end

  describe 'PUT update' do
    context 'with valid params' do
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
    end

    context 'with invalid params' do
      it 'raises error exception if particular candidate is not found' do
        params = {
          id: 0,
          first_name: Faker::Name.name
        }
        put :update, params: params

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST #invite' do
    context 'with valid params' do
      it 'sends mail invitation to candidate' do
        params = {
          emails: Faker::Internet.email,
          drife_id: @drive.id
        }

        post :invite, params: params

        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid params' do
      it 'raises error exception if particular candidate is not found' do
        params = {
          emails: Faker::Internet.email,
          drife_id: Faker::Number.number
        }
        post :invite, params: params

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'GET candidate_test_time_left' do
    it 'returns the time remaining for a candidate if test is in progress' do
      params = {
        drife_id: @drive.id,
        candidate_id: @candidate.id
      }
      get :candidate_test_time_left, params: params

      parsed_json_data = json
      expect(parsed_json_data['data']['time_left']).to be > 0
      expect(response).to have_http_status(:ok)
    end

    it 'test had already completed' do
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
