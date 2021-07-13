# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::SnapshotsController, type: :controller do
  let(:organization) { create(:organization) }
  let(:role) { create(:role) }
  let(:user) { create(:user) }
  let(:drive) do
    create(:drive, created_by_id: user.id, updated_by_id: user.id,
                   organization: organization)
  end
  let(:candidate) { create(:candidate) }
  let!(:drives_candidate) do
    create(:drives_candidate, candidate_id: candidate.id, drive_id: drive.id, drive_start_time: DateTime.current,
                              drive_end_time: DateTime.current + 1.hours)
  end
  let!(:snapshot) { create(:snapshot, drives_candidate: drives_candidate) }

  describe 'GET #INDEX' do
    context 'with valid params' do
      it 'returns all snapshots related to a drives candidate' do
        get :index, params: { drive_id: drive.id, candidate_id: candidate.id }

        data = json

        expect(data['data']['snapshots'].count).to eq(1)
        expect(response).to have_http_status(:ok)
      end
    end
    context 'with invalid params' do
      it 'returns the not found error as passing random id which is not present in database' do
        get :index, params: { drive_id: Faker::Number.number, candidate_id: Faker::Number.number }

        expect(response.body).to eq(I18n.t('not_found.message'))
        expect(response).to have_http_status(400)
      end
    end
  end

  describe 'POST #presignedUrl' do
    context 'with valid params' do
      it 'returns all snapshots related to a drives candidate' do
        post :presigned_url, params: { drive_id: drive.id, candidate_id: candidate.id }
        url = "#{ENV['S3_BUCKET_URL']}/#{drive.name.gsub(' ', '%20')}/#{candidate.id}-#{candidate.first_name}-#{candidate.last_name}"
        data = json

        expect(data['data']['url'].split('?').first).to include(url)
        expect(response).to have_http_status(:ok)
      end
    end
    context 'with invalid params' do
      it 'returns the not found error as passing random id which is not present in database' do
        post :presigned_url, params: { drive_id: Faker::Number.number, candidate_id: Faker::Number.number }

        expect(response.body).to eq(I18n.t('not_found.message'))
        expect(response).to have_http_status(400)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'returns all snapshots related to a drives candidate' do
        post :create, params: { drive_id: drive.id, candidate_id: candidate.id, presigned_url: Faker::Internet.url }

        data = json

        expect(data['data'].count).to eq(1)
        expect(data['data']['snapshot']['candidate_name']).to eq("#{candidate.first_name} #{candidate.last_name}")
        expect(response).to have_http_status(:ok)
      end
    end
    context 'with invalid params' do
      it 'returns the not found error as passing random id which is not present in database' do
        post :create, params: { drive_id: Faker::Number.number, candidate_id: Faker::Number.number }

        expect(response.body).to eq(I18n.t('not_found.message'))
        expect(response).to have_http_status(400)
      end
    end
  end
end
