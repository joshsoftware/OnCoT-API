# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Admin::ProblemsController, type: :controller do
  context 'problems Actions' do
    let(:organization) { create(:organization) }
    let(:role) { create(:role) }
    let(:user) { create(:user) }
    let(:problem) { create(:problem, created_by_id: user.id, updated_by_id: user.id, organization: organization) }

    it 'Creates the problem' do
      post :create,
           params: { title: 'a', description: 'b', created_at: Time.now, updated_at: Time.now, created_by_id: user.id,
                     updated_by_id: user.id, organization_id: organization.id }

      problem = parseJson(response.body)

      p problem['title']
      expect(problem['title']).to eq('a')
      expect(response).to have_http_status(:ok)
    end

    it 'Updates a problem' do
      put :update,
          params: { id: problem.id, title: 'b', description: 'b', created_at: Time.now, updated_at: Time.now,
                    created_by_id: user.id, updated_by_id: user.id, organization_id: organization.id }

      problem = parseJson(response.body)
      expect(problem['title']).to eq('b')
      expect(response).to have_http_status(:ok)
    end

    it 'shows a problem' do
      get :show, params: { id: problem.id }

      expect(response).to have_http_status(:ok)
    end

    it 'shows all problems' do
      get :index

      expect(response).to have_http_status(:ok)
    end

    it 'destroy a problem' do
      delete :destroy, params: { id: problem.id }

      expect(response).to have_http_status(:ok)
    end
  end
end
