# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CandidatesController, type: :controller do
  context 'candidates#update' do
    let(:organization) { create(:organization) }
    let(:user) { create(:user) }
    let(:drive) do
      create(:drive, updated_by_id: user.id, created_by_id: user.id,
                     organization: organization)
    end

    let(:candidate) { create(:candidate, drive_id: drive.id) }

    it 'update the candidate details' do
      get :update, params: { id: candidate.id }

      expect(response.body).to eq({ data: candidate, message: 'Success' }.to_json)
      expect(response).to have_http_status(200)
    end
  end
end
