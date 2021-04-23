# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::SnapshotsController, type: :controller do
  let(:organization) { create(:organization) }
  let(:user) { create(:user) }
  let(:drive) { create(:drive, created_by_id: user.id, updated_by_id: user.id, organization: organization) }
  let(:candidate) { create(:candidate) }
  let!(:snapshot) { create(:snapshot, drive_id: drive.id, candidate_id: candidate.id) }

  describe 'GET #INDEX' do
    context 'with valid params' do
      it 'returns all snapshots related to candidate of a drive' do
        get :index, params: { drive_id: drive.id, candidate_id: candidate.id }

        data = json

        expect(data['data']['snapshots'].count).to eq(1)
        expect(response).to have_http_status(:ok)
      end
    end
    context 'with invalid params' do
      it 'returns the not found error as passing random id which is not present in database' do
        get :index, params: { drive_id: Faker::Number.number }

        expect(response.body).to eq(I18n.t('not_found.message'))
        expect(response).to have_http_status(404)
      end
      it 'returns the not found error as passing random id which is not present in database' do
        get :index, params: { candidate_id: Faker::Number.number }

        expect(response.body).to eq(I18n.t('not_found.message'))
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST #CREATE' do
    context 'with valid params' do
      it 'returns all snapshots related to candidate of a drive' do
        post :create, params: { url: Faker::Internet.url, drive_id: drive.id, candidate_id: candidate.id }

        data = json

        expect(data['data']['snapshot']['drive_id']).to eq(drive.id)
        expect(data['data']['snapshot']['candidate_id']).to eq(candidate.id)
        expect(response).to have_http_status(:ok)
      end
    end
    context 'with invalid params' do
      it 'returns the not found error as not passing candidate_id' do
        post :create, params: { drive_id: drive.id }

        expect(response.body).to eq(I18n.t('not_found.message'))
        expect(response).to have_http_status(404)
      end
      it 'returns the not found error as passing random id which is not present in database' do
        get :index, params: { candidate_id: Faker::Number.number, drive_id: drive.id }

        expect(response.body).to eq(I18n.t('not_found.message'))
        expect(response).to have_http_status(404)
      end
    end
  end
end
