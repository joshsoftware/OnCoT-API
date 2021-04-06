# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ProblemsController, type: :controller do
  describe 'GET index' do
    context 'with correct drive id ' do
      before do
        organization = create(:organization)
        user = create(:user)
        drive = create(:drive, updated_by_id: user.id, created_by_id: user.id,
                               organization_id: organization.id)
        @problem = create(:problem, updated_by_id: user.id, created_by_id: user.id,
                                    organization: organization)

        create(:drives_problem, drive_id: drive.id, problem_id: @problem.id)
        get :index, params: { id: drive.id }
      end
      it 'returns the problem data' do
        data = json

        expect(data['data']['title']).to eq(@problem.title)
        expect(data['data']['description']).to eq(@problem.description)
        expect(data['message']).to eq('Success')
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
