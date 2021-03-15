# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CandidatesController, type: :controller do
  describe 'update' do
    context ' testing with correct id' do
      let(:organization) { create(:organization) }
      let(:user) { create(:user) }
      let(:candidate) { create(:candidate) }
      let(:drive) do
        create(:drive, updated_by_id: user.id, created_by_id: user.id,
                       organization: organization)
      end

      let(:drives_candidate) { create(:drives_candidate, drive_id: drive.id, candidate_id: candidate.id) }

      it 'update the candidate details' do
        patch :update, params: { id: drives_candidate.token }

        expect(response.body).to eq({ data: candidate, message: 'Success' }.to_json)
        expect(response).to have_http_status(200)
      end
    end

    context 'testing with random id which is not present in database' do
      it 'returns the not found error' do
        patch :update, params: { id: Faker::Number }

        expect(response).to have_http_status(404)
      end
    end
  end
end
