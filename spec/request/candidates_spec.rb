# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CandidatesController, type: :controller do
  context 'When testing the update method' do
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

    it 'returns the not found error as passing random id which is not present in database' do
      patch :update, params: { id: Faker::Number }

      expect(response).to have_http_status(404)
    end
  end
end
