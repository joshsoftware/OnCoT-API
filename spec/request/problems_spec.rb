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
                       organization: organization)
    end
    let(:drives_problem) { create(:drives_problem, drive_id: drive.id, problem_id: problem.id) }

    it 'returns the problem data' do
      get '/problems/:token' => 'problems#show', params: { id: drives_problem.problem_id }

      expect(response.body).to eq({ data: problem, message: 'Success' }.to_json)
      expect(response).to have_http_status(200)
    end

    it 'returns the error as passing random id which is not present in database' do
      get :show, params: { id: Faker::Number }

      expect(response.body).to eq({ message: 'Error, Please try again' }.to_json)
    end
  end
end
