# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::DrivesController, type: :controller do
  let(:organization) { create(:organization) }
  let(:role) { create(:role) }
  let(:user) { create(:user, role_id: role.id) }
  let(:drive1) do
    create(:drive, updated_by_id: user.id, created_by_id: user.id,
                   organization: organization, start_time: DateTime.now.localtime + 1.hours,
                   end_time: DateTime.now.localtime + 3.hours, duration: 10_800)
  end
  let(:drive2) do
    create(:drive, updated_by_id: user.id, created_by_id: user.id,
                   organization: organization, start_time: DateTime.now.localtime - 1.hours,
                   end_time: DateTime.now.localtime + 1.hours, duration: 10_800)
  end
  let(:drive3) do
    create(:drive, updated_by_id: user.id, created_by_id: user.id,
                   organization: organization, start_time: DateTime.now.localtime - 3.hours,
                   end_time: DateTime.now.localtime - 1.hours, duration: 10_800)
  end
  let(:candidate) { create(:candidate) }
  let(:drives_candidate1) { create(:drives_candidate, drive_id: drive1.id, candidate_id: candidate.id) }
  let(:drives_candidate2) { create(:drives_candidate, drive_id: drive2.id, candidate_id: candidate.id) }
  let(:drives_candidate3) { create(:drives_candidate, drive_id: drive3.id, candidate_id: candidate.id) }

  describe 'GET #show' do
    context 'with valid params' do
      it 'returns drive details' do
        get :show, params: { id: drives_candidate1.token }

        data = json

        expect(data['data']['drive']['name']).to eq(drive1.name)
        expect(response).to have_http_status(200)
      end
    end
    context 'with invalid params' do
      it 'fails request' do
        get :show, params: { id: Faker::Number.number }

        expect(response.body).to eq(I18n.t('drive_not_found.message'))
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'GET #drive_time_left' do
    context 'with valid params' do
      it 'returns time left to start drive' do
        get :drive_time_left, params: { id: drive1.id }

        data = json

        expect(data['message']).to eq(I18n.t('drive.yet_to_start'))
        expect(response).to have_http_status(200)
      end
      it 'returns drive is already started' do
        get :drive_time_left, params: { id: drive2.id }

        data = json

        expect(data['message']).to eq(I18n.t('drive.started'))
        expect(response).to have_http_status(200)
      end
      it 'returns drive has completed' do
        get :drive_time_left, params: { id: drive3.id }

        data = json

        expect(data['message']).to eq(I18n.t('drive.ended'))
        expect(response).to have_http_status(200)
      end
    end
    context 'with invalid params' do
      it 'fails request' do
        get :drive_time_left, params: { id: Faker::Number.number }

        expect(response.body).to eq(I18n.t('not_found.message'))
        expect(response).to have_http_status(404)
      end
    end
  end
end
