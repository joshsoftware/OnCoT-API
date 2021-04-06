# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::DrivesController, type: :controller do
  let(:organization) { create(:organization) }
  let(:role) { create(:role) }
  let(:user) { create(:user, role_id: role.id) }
  let(:drive) do
    create(:drive, updated_by_id: user.id, created_by_id: user.id,
                   organization: organization)
  end
  let(:candidate) { create(:candidate) }
  let(:drives_candidate) { create(:drives_candidate, drive_id: drive.id, candidate_id: candidate.id) }

  describe 'GET #show' do
    context 'with valid params' do
      it 'returns drive details' do
        get :show, params: { id: drives_candidate.token }

        data = json

        expect(data['data']['name']).to eq(drive.name)
        expect(response).to have_http_status(200)
      end
    end
    context 'with invalid params' do
      it 'fails request' do
        get :show, params: { id: Faker::Number.number }

        expect(response.body).to eq('token is not present')
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'GET #drive_time_left' do
    context 'with valid params' do
      it 'returns time left to start drive' do
        get :drive_time_left, params: { id: drive.id }

        data = json

        expect(data['message']).to eq('Drive has already started.')
        expect(response).to have_http_status(200)
      end
    end
    context 'with invalid params' do
      it 'fails request' do
        get :drive_time_left, params: { id: Faker::Number.number }

        expect(response.body).to eq('Record not found')
        expect(response).to have_http_status(404)
      end
    end
  end
end
