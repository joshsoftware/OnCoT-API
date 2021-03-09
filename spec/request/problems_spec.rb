require 'rails_helper'

RSpec.describe Api::V1::Admin::ProblemsController, type: :controller do
  context 'problems#create' do
  
    let(:organization) { create(:organization) }
    let(:role) { create(:role) }
    let(:user) { create(:user) }
    let(:problem) { create(:problem, created_by_id: user.id, updated_by_id: user.id, organization: organization) }
    
    it 'Creates the problem' do
      post :create , params: {title: "a", description:"b", created_at: Time.now, updated_at: Time.now, created_by_id: user.id, updated_by_id: user.id, organization_id: organization.id}

      parsed_problem_data = JSON.parse(response.body)
      p response.message
      expect(parsed_problem_data['data']['problem']["title"]).to eq("a")
      expect(response).to have_http_status(200)
    end

    it 'Updates a problem' do

      put :update , params: {id: problem.id, title: "b", description:"b", created_at: Time.now, updated_at: Time.now, created_by_id: user.id, updated_by_id: user.id, organization_id: organization.id}

      parsed_problem_data = JSON.parse(response.body)
      expect(parsed_problem_data['data']['problem']["title"]).to eq("b")
      expect(response).to have_http_status(200)
    end

    it 'shows a problem' do
      get :show , params: {id: problem.id}
      
      expect(response).to have_http_status(200)
    end

    it 'shows all problems' do
      get :index 
      
      expect(response).to have_http_status(200)
    end

    it 'destroy a problem' do
      delete :destroy , params: {id: problem.id}
    
      expect(response).to have_http_status(200)
    end
  end
end
