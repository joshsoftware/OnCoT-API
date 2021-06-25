# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Admin::AssessmentsController, type: :controller do
  let!(:organization) { create(:organization, auth_token:'bearer_token') }
  let(:role) { create(:role) }
  let(:user) { create(:user, role_id: role.id) }
  let(:drive) { create(:drive, created_by_id: user.id, updated_by_id: user.id, organization: organization, is_assessment: true) }

  let(:problem) { create(:problem, created_by_id: user.id, updated_by_id: user.id) }

  describe 'GET#index' do
    before do
      create(:drive, created_by_id: user.id, updated_by_id: user.id, organization: organization, is_assessment: true)
      create(:drive, created_by_id: user.id, updated_by_id: user.id, organization: organization)
      create(:drive, created_by_id: user.id, updated_by_id: user.id, organization: organization, is_assessment: true)
    end
    context 'when user is logged in' do
      it 'returns all assessments' do
        request.headers.merge!(HTTP_AUTH_TOKEN: 'bearer_token')
        get :index

        data = json

        expect(data['data']['assessments'].count).to eq(2)
        expect(response).to have_http_status(:ok)
      end
    end
    context 'When user is not logged in' do
      it ' ask for login ' do
        get :index

        expect(response.body).to eq('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(400)
      end
    end
  end

  describe 'action#create' do
    context 'when user is logged in' do
      context 'with valid params' do
        it ' finds or creates a candidate and send invitation' do
          request.headers.merge!(HTTP_AUTH_TOKEN: 'bearer_token')
          post :create, params: { assessment_id: drive.id, email: Faker::Internet.email, start_time: DateTime.current, end_time: DateTime.current+1.hours }

          expect(response).to have_http_status(:ok)
          expect(Candidate.count).to eq(1)
        end
      end
      context 'with invalid params' do
        it ' returns errors as passing wrong assessment_id' do
          request.headers.merge!(HTTP_AUTH_TOKEN: 'bearer_token')
          post :create, params: { assessment_id: Faker::Number.number, email: Faker::Internet.email, start_time: DateTime.current, end_time: DateTime.current + 1.hours }

          expect(response.body).to eq(I18n.t('not_found.message'))
        end
        it ' returns errors as start_time is greater than end_time' do
          request.headers.merge!(HTTP_AUTH_TOKEN: 'bearer_token')
          post :create, params: { assessment_id: drive.id, email: Faker::Internet.email, start_time: DateTime.current, end_time: DateTime.current - 30.minutes }
          data = json

          expect(data.first).to eq(I18n.t('drive_end_time.invalid'))
        end
      end
    end

    context 'When user is not logged in' do
      it ' ask for login ' do
        post :create, params: { assessment_id: drive.id, email: Faker::Internet.email }

        expect(response.body).to eq('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(400)
      end
    end
  end
end
