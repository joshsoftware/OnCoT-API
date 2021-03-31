# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DriveEndsController, type: :controller do
  describe 'GET #show' do
    context 'with valid params' do
      before do
        organization = create(:organization)
        user = create(:user)
        candidate = create(:candidate)
        drive = create(:drive, updated_by_id: user.id, created_by_id: user.id,
                               organization: organization)
        drives_candidate = create(:drives_candidate, drive_id: drive.id, candidate_id: candidate.id)
        get :show, params: { id: drives_candidate.candidate_id }
      end
      it 'returns success message' do
        result = json

        expect(result['data']).to eq(nil)
        expect(result['message']).to eq(I18n.t('success.message'))
        expect(response).to have_http_status(200)
      end
    end

    context 'with invalid params' do
      it 'returns not found message' do
        get :show, params: { id: Faker::Number }

        expect(response.body).to eq(I18n.t('not_found.message'))
      end
    end
  end
end
