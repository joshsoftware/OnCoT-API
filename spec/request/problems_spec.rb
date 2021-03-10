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
           params: { title: 'a', description: 'b', created_at: Time.now, updated_at: Time.now, created_by_id: user.id,
                     updated_by_id: user.id, organization_id: organization.id }

      problem = parse_json(response.body)

      p problem['title']
      expect(problem['problem']['title']).to eq('a')
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PUT Update' do
    it 'Updates a problem' do
      put :update,
          params: { id: problem.id, title: 'b', description: 'b', created_at: Time.now, updated_at: Time.now,
                    created_by_id: user.id, updated_by_id: user.id, organization_id: organization.id }

      problem = parse_json(response.body)
      expect(problem['problem']['title']).to eq('b')
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET show' do
    it 'shows a problem' do
      get :show, params: { id: problem.id }

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET index' do
    it 'shows all problems' do
      get :index

      expect(response).to have_http_status(:ok)
    end
  end
end
