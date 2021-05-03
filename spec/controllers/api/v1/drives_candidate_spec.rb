# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::DrivesCandidatesController, type: :controller do
  before do
    organization = create(:organization)
    user = create(:user)
    @candidate = create(:candidate)
    @drive = create(:drive, updated_by_id: user.id, organization: organization,
                            created_by_id: user.id)
    @drives_candidate = create(:drives_candidate, candidate_id: @candidate.id, drive_id: @drive.id)
    @drives_candidate1 = create(:drives_candidate, candidate_id: @candidate.id, drive_id: @drive.id, 
                                  completed_at: DateTime.now.localtime)
  end
  describe 'PATCH #update' do
    context 'with valid params' do
      it 'Updates the completed_at field' do
        patch :update, params: { id: @candidate.id, drive_id: @drive.id }
        result = json
        expect(result['data']).to eq(@drives_candidate.reload.completed_at.iso8601.to_s)
        expect(result['message']).to eq(I18n.t('success.message'))
      end
    end

    context 'with invalid params' do
      it 'returns not found message' do
        patch :update, params: { id: Faker::Number, drive_id: Faker::Number }

        expect(response.body).to eq(I18n.t('not_found.message'))
      end
    end
  end

  describe 'GET appear_for_test' do
    context 'with valid params' do
      it 'return success message' do
        params = {
          drives_candidate_id: @drives_candidate.id
        }
        get :appeared_for_test, params: params

        result = json
        expect(result['message']).to eq(I18n.t('success.message'))
      end

      it 'returns error message' do
        params = {
          drives_candidate_id: @drives_candidate1.id
        }
        
        get :appeared_for_test, params: params

        expect(response.body).to eq(I18n.t('error.message'))
      end
    end

    context 'with invalid params' do
      it 'returns not found message' do
        params = {
          drives_candidate_id: Faker::Number.number
        }
        get :appeared_for_test, params: params

        expect(response.body).to eq(I18n.t('not_found.message'))
      end
    end
  end
end
