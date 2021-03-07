require 'rails_helper'

RSpec.describe ProblemsController, type: :controller do
  context 'problem#show' do
    let(:organization) { create(:organization) }
    let(:user) { create(:user) }
    let(:problem) do
      create(:problem, updated_by_id: user.id, created_by_id: user.id,
                       organization: organization)
    end

    it 'returns the problem data' do
      get :show, params: { id: problem.id }

      expect(response.body).to eq({ data: problem, message: 'Success' }.to_json)
      expect(response).to have_http_status(200)
    end

    it 'returns the error as passing random id which is not present in database' do
      get :show, params: { id: Faker::Number }

      expect(response.body).to eq({ message: 'Problem not exists' }.to_json)
    end
  end
end
