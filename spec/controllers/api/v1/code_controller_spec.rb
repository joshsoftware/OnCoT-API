# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::CodesController, type: :controller do
  let(:organization) { create(:organization) }
  let(:role) { create(:role) }
  let(:user) { create(:user, role_id: role.id) }
  let(:drive) do
    create(:drive, updated_by_id: user.id, created_by_id: user.id,
                   organization: organization, start_time: DateTime.current + 1.hours,
                   end_time: DateTime.current + 3.hours, duration: 10_800)
  end
  let(:candidate) { create(:candidate) }
  let(:drives_candidate) do
    create(:drives_candidate, drive_id: drive.id, candidate_id: candidate.id, drive_start_time: DateTime.current,
                              drive_end_time: DateTime.current + 1.hour)
  end
  let(:problem) { create(:problem, updated_by_id: user.id, created_by_id: user.id, organization: organization) }
  let!(:code) { create(:code, drives_candidate_id: drives_candidate.id, problem_id: problem.id) }

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates code (auto-submit) in database' do
        post :create, params: { answer: "print('world')", language_id: 71, token: drives_candidate.token, problem_id: problem.id }
        data = json
        expect(data['message']).to eq(I18n.t('success.message'))
        expect(data['data']['code']['problem_id']).to eq(problem.id)
        expect(Code.count).to eq(1)
      end
    end

    context 'with invalid params' do
      it 'returns record not found message when problem_id is invalid' do
        post :create,
             params: { source_code: "print('world')", language_id: 71, token: drives_candidate.token,
                       problem_id: Faker::Number.number }
        data = json
        expect(data['message']).to eq(I18n.t('not_found.message'))
      end
      it 'returns record not found message when token is invalid' do
        post :create,
             params: { source_code: "print('world')", language_id: 71, token: Faker::Internet.uuid, problem_id: problem.id }
        data = json
        expect(data['message']).to eq(I18n.t('not_found.message'))
        expect(data['data'].count).to eq(0)
      end
    end
  end

  describe 'GET #show' do
    context 'with valid params' do
      it 'returns details of a code of a specific problem' do
        get :show, params: { token: drives_candidate.token, problem_id: problem.id }
        data = json
        expect(response).to have_http_status(:success)
        expect(data['data'].count).to eq(1)
        expect(data['message']).to eq(I18n.t('success.message'))
      end
    end

    context 'with invalid params' do
      it 'returns record not found message when problem_id is invalid' do
        get :show, params: { token: drives_candidate.token, problem_id: Faker::Number.number }
        data = json
        expect(data['message']).to eq(I18n.t('not_found.message'))
      end
      it 'returns record not found message when token is invalid' do
        get :show, params: { token: Faker::Internet.uuid, problem_id: problem.id }
        data = json
        expect(data['message']).to eq(I18n.t('not_found.message'))
        expect(data['data'].count).to eq(0)
      end
    end
  end
end
