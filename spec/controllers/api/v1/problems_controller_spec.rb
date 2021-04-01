# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ProblemsController, type: :controller do
  describe 'GET index' do
    context 'with correct id ' do
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
        get :index, params: { id: drives_problem.problem_id }

        expect(response.body).to eq({ data: problem, message: 'Success' }.to_json)
        expect(response).to have_http_status(200)
      end
    end

    context 'with random id which is not present in database' do
      it 'returns not found error ' do
        get :index, params: { id: Faker::Number }

        expect(response).to have_http_status(404)
      end
    end
  end
end
