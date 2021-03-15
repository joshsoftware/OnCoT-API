# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Admin::ProblemsController, type: :controller do
  let(:organization) { create(:organization) }
  let(:role) { create(:role) }
  let(:user) { create(:user) }
  let(:problem) { create(:problem, created_by_id: user.id, updated_by_id: user.id, organization: organization) }

  describe 'POST Create' do
    it 'Creates the problem' do
      post :create,
           params: { title: 'a', description: 'b', created_by_id: user.id,
                     updated_by_id: user.id, organization_id: organization.id }

      problem = json

      expect(problem['data']['problem']['title']).to eq('a')
      expect(response).to have_http_status(:ok)
    end

    it 'fails Create action as not passing organization id' do
      post :create,
           params: { title: 'a', description: 'b', created_by_id: user.id,
                     updated_by_id: user.id }

      expect(response).to have_http_status(400)
    end
  end

  describe 'PUT Update' do
    it 'Updates a problem' do
      expect do
        put :update,
            params: { id: problem.id, title: 'b', description: 'b',
                      created_by_id: user.id, updated_by_id: user.id, organization_id: organization.id }
      end.to change { problem.reload.title }.from(problem.title).to('b')

      expect(response).to have_http_status(:ok)
    end

    it 'returns the not found error as passing random id which is not present in database' do
      patch :update, params: { id: Faker::Number }
      expect(response).to have_http_status(404)
    end
  end

  describe 'GET show' do
    it 'shows a problem' do
      get :show, params: { id: problem.id }

      data = json
      expect(data['data']['problem']['title']).to eq(problem.title)
      expect(response).to have_http_status(:ok)
    end

    it 'returns the not found error as passing random id which is not present in database' do
      patch :update, params: { id: Faker::Number }
      expect(response).to have_http_status(404)
    end
  end

  describe 'GET index' do
    it 'shows all problems' do
      get :index

      data = json
      expect(data['data']['problems'].count).to eq(Problem.count)
      expect(response).to have_http_status(:ok)
    end
    it 'returns the not found error ' do
      patch :update, params: { id: Faker::Number }
      expect(response).to have_http_status(404)
    end
  end
end
