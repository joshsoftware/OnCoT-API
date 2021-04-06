# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::DrivesCandidatesController, type: :controller do
  describe 'PATCH #update' do
    context 'with valid params' do
      before do
        organization = create(:organization)
        user = create(:user)
        candidate = create(:candidate)
        drive = create(:drive, updated_by_id: user.id, created_by_id: user.id,
                               organization: organization)
        @drives_candidate = create(:drives_candidate, drive_id: drive.id, candidate_id: candidate.id)
      end

      it 'Updates the completed_at field' do
        patch :update, params: { id: @drives_candidate.candidate_id }

        result = json
        expect(result['data']).to eq(@drives_candidate.reload.completed_at.iso8601.to_s)
        expect(result['message']).to eq(I18n.t('success.message'))
      end
    end

    context 'with invalid params' do
      it 'returns not found message' do
        patch :update, params: { id: Faker::Number }

        expect(response.body).to eq(I18n.t('not_found.message'))
      end
    end
  end
end
