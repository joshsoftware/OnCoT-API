# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Admin::ProblemsController, type: :controller do
  let(:organization) { create(:organization) }
  let(:role) { create(:role) }
  let(:user) { create(:user) }
  let(:problem) do
    create(:problem, created_by_id: user.id,
                     updated_by_id: user.id, organization: organization)
  end

  describe 'POST #CREATE' do
    context 'When user is logged in' do
      before do
        auth_tokens_for_user(user)
      end
      it ' creates the problem' do
        @request.env['devise.mapping'] = Devise.mappings[:user]

        post :create,
             params: { title: 'a', description: 'b', created_by_id: user.id,
                       updated_by_id: user.id, organization_id: organization.id }

        problem = json

        expect(problem['data']['problem']['title']).to eq('a')
        expect(response.has_header?('access-token')).to eq(true)
        expect(response).to have_http_status(:ok)
      end

      it ' creates problem even though not passing organization id,
        created_by_id, it takes from sessions' do
        post :create,
             params: { title: Faker::Lorem.sentence, description: Faker::Lorem.paragraph }

        problem = json
        expect(problem['data']['problem']['created_by_id']).to eq(user.id)
        expect(response).to have_http_status(200)
      end
    end

    context 'when user is not logged in' do
      it ' ask for login ' do
        post :create,
             params: { title: Faker::Lorem.sentence, description: Faker::Lorem.paragraph }

        problem = json

        expect(problem['errors'].first).to eq('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'PUT/PATCH #UPDATE' do
    context 'When user is logged in' do
      before do
        auth_tokens_for_user(user)
      end
      it 'Updates the problem' do
        expect do
          put :update,
              params: { id: problem.id, title: 'b', description: Faker::Lorem.paragraph }
        end.to change { problem.reload.title }.from(problem.title).to('b')

        expect(response.has_header?('access-token')).to eq(true)
        expect(response).to have_http_status(:ok)
      end

      it 'returns the not found error as passing random id which is not present in database' do
        patch :update, params: { id: Faker::Number.number }

        expect(response.body).to eq('Record not found')
        expect(response).to have_http_status(404)
      end
    end

    context 'when user is not logged in' do
      it ' ask to login ' do
        patch :update, params: { id: problem.id }
        problem = json
        expect(problem['errors'].first).to eq('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'GET #SHOW' do
    context 'when user is logged in' do
      before do
        auth_tokens_for_user(user)
      end
      it 'shows a problem' do
        get :show, params: { id: problem.id }

        data = json
        expect(data['data']['problem']['title']).to eq(problem.title)
        expect(response.has_header?('access-token')).to eq(true)
        expect(response).to have_http_status(:ok)
      end

      it 'returns the not found error as passing random id which is not present in database' do
        get :show, params: { id: Faker::Number }
        expect(response.body).to eq('Record not found')
        expect(response).to have_http_status(404)
      end
    end

    context 'when user is not logged in' do
      it ' ask to login' do
        get :show, params: { id: problem.id }

        problem = json
        expect(problem['errors'].first).to eq('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'GET index' do
    context 'when user is logged in' do
      before do
        auth_tokens_for_user(user)
      end
      it 'shows all problems' do
        get :index

        data = json
        expect(data['data']['problems'].count).to eq(Problem.count)
        expect(response.has_header?('access-token')).to eq(true)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is not logged in' do
      it ' ask to login' do
        get :index
        problems = json
        expect(problems['errors'].first).to eq('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(401)
      end
    end
  end
end