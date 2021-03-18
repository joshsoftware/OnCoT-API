# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Admin::ProblemsController, type: :controller do
  let(:organization) { create(:organization) }

  describe 'POST Create' do
    context 'Admin as user' do
      let(:role) { create(:role) }
      let(:user) { create(:user) }
      let(:problem) do
        create(:problem, created_by_id: user.id,
                         updated_by_id: user.id, organization: organization)
      end

      it 'Creates the problem' do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        request.headers.merge! user.create_new_auth_token
        post :create,
             params: { title: 'a', description: 'b', created_by_id: user.id,
                       updated_by_id: user.id, organization_id: organization.id }

        problem = json

        expect(problem['data']['problem']['title']).to eq('a')
        expect(response.has_header?('access-token')).to eq(true)
        expect(response).to have_http_status(:ok)
      end

      it 'will Create problem even though not passing organization id,
        created_by_id, it takes from sessions' do
        request.headers.merge! user.create_new_auth_token

        post :create,
             params: { title: Faker::Lorem.sentence, description: Faker::Lorem.paragraph }

        problem = json
        expect(problem['data']['problem']['created_by_id']).to eq(user.id)
        expect(response).to have_http_status(200)
      end
      it 'will ask for login as not logged in' do
        post :create,
             params: { title: Faker::Lorem.sentence, description: Faker::Lorem.paragraph }

        problem = json

        expect(problem['errors'].first).to eq('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(401)
      end
    end

    context 'Reviewer as a user' do
      let(:role) { Role.create!(name: 'Reviewer') }
      let(:user) do
        User.create!(email: Faker::Internet.email, password: Faker::Internet.password,
                     role: role, organization: organization)
      end

      let(:problem) do
        create(:problem, created_by_id: user.id, updated_by_id: user.id,
                         organization: organization)
      end

      it 'will throw forbidden error' do
        request.headers.merge! user.create_new_auth_token
        post :create, params: { title: Faker::Lorem.sentence, description: Faker::Lorem.paragraph }

        expect(response.body).to eq('Unothorized user, login as admin')
        expect(response).to have_http_status(403)
      end
    end
  end

  describe 'PUT/PATCH Update' do
    context 'Admin as user' do
      let(:role) { create(:role) }
      let(:user) { create(:user) }
      let(:problem) do
        create(:problem, created_by_id: user.id,
                         updated_by_id: user.id, organization: organization)
      end

      it 'Updates a problem' do
        request.headers.merge! user.create_new_auth_token
        expect do
          put :update,
              params: { id: problem.id, title: 'b', description: Faker::Lorem.paragraph }
        end.to change { problem.reload.title }.from(problem.title).to('b')

        expect(response.has_header?('access-token')).to eq(true)
        expect(response).to have_http_status(:ok)
      end

      it 'returns the not found error as passing random id which is not present in database' do
        request.headers.merge! user.create_new_auth_token
        patch :update, params: { id: Faker::Number }
        expect(response.body).to eq('Record not found')
        expect(response).to have_http_status(404)
      end
      it 'will ask for login as not logged in' do
        patch :update, params: { id: problem.id }
        problem = json
        expect(problem['errors'].first).to eq('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(401)
      end
    end

    context 'Reviewer as a user' do
      let(:role) { Role.create!(name: 'Reviewer') }
      let(:user) do
        User.create!(email: Faker::Internet.email, password: Faker::Internet.password,
                     role: role, organization: organization)
      end

      let(:problem) do
        create(:problem, created_by_id: user.id, updated_by_id: user.id,
                         organization: organization)
      end

      it 'will throw forbidden error' do
        request.headers.merge! user.create_new_auth_token
        patch :update, params: { id: problem.id, description: Faker::Lorem.paragraph }

        expect(response.body).to eq('Unothorized user, login as admin')
        expect(response).to have_http_status(403)
      end
    end
  end

  describe 'GET show' do
    context 'Admin as user' do
      let(:role) { create(:role) }
      let(:user) { create(:user) }
      let(:problem) do
        create(:problem, created_by_id: user.id,
                         updated_by_id: user.id, organization: organization)
      end

      it 'shows a problem' do
        request.headers.merge! user.create_new_auth_token
        get :show, params: { id: problem.id }

        data = json
        expect(data['data']['problem']['title']).to eq(problem.title)
        expect(response.has_header?('access-token')).to eq(true)
        expect(response).to have_http_status(:ok)
      end

      it 'returns the not found error as passing random id which is not present in database' do
        request.headers.merge! user.create_new_auth_token
        get :show, params: { id: Faker::Number }
        expect(response.body).to eq('Record not found')
        expect(response).to have_http_status(404)
      end
      it 'will ask for login as not logged in' do
        get :show, params: { id: problem.id }
        problem = json
        expect(problem['errors'].first).to eq('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(401)
      end
    end
    context 'Reviewer as a user' do
      let(:role) { Role.create!(name: 'Reviewer') }
      let(:user) do
        User.create!(email: Faker::Internet.email, password: Faker::Internet.password,
                     role: role, organization: organization)
      end

      let(:problem) do
        create(:problem, created_by_id: user.id, updated_by_id: user.id,
                         organization: organization)
      end

      it 'will ask for login as not logged in' do
        get :show, params: { id: problem.id }
        problem = json
        expect(problem['errors'].first).to eq('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'GET index' do
    context 'Admin as user' do
      let(:role) { create(:role) }
      let(:user) { create(:user) }
      let(:problem) do
        create(:problem, created_by_id: user.id,
                         updated_by_id: user.id, organization: organization)
      end

      it 'shows all problems' do
        request.headers.merge! user.create_new_auth_token
        get :index

        data = json
        expect(data['data']['problems'].count).to eq(Problem.count)
        expect(response.has_header?('access-token')).to eq(true)
        expect(response).to have_http_status(:ok)
      end
      it 'will ask for login as not logged in' do
        get :index
        problems = json
        expect(problems['errors'].first).to eq('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(401)
      end
    end

    context 'Reviewer as a user' do
      let(:role) { Role.create!(name: 'Reviewer') }
      let(:user) do
        User.create!(email: Faker::Internet.email, password: Faker::Internet.password,
                     role: role, organization: organization)
      end

      let(:problem) do
        create(:problem, created_by_id: user.id, updated_by_id: user.id,
                         organization: organization)
      end

      it 'shows all problems' do
        request.headers.merge! user.create_new_auth_token
        get :index

        data = json
        expect(data['data']['problems'].count).to eq(Problem.count)
        expect(response.has_header?('access-token')).to eq(true)
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
