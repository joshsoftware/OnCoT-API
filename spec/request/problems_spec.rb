require 'rails_helper'

RSpec.describe ProblemsController, type: :controller do
  context 'problem#show' do
    let(:organization) { create(:organization) }
    let(:user) { create(:user) }
    let(:drive) do
      create(:drive, updated_by_id: user.id, created_by_id: user.id,
                     organization: organization)
    end

    let(:problem) do
      create(:problem, updated_by_id: user.id, created_by_id: user.id,
                       organization: organization, drive_id: drive.id)
    end

    it 'returns the problem data' do
      get :display, params: { id: problem.id }

      expect(response.body).to eq({ data: problem, message: 'Success' }.to_json)
      expect(response).to have_http_status(200)
    end

    it 'returns the not found error as passing random id which is not present in database' do
      get :display, params: { id: Faker::Number }

      expect(response).to have_http_status(404)
    end
  end
end
