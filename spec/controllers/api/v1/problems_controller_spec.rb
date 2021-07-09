# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ProblemsController, type: :controller do
  describe 'GET index' do
    context 'with correct drive id ' do
      before do
        organization = create(:organization)
        user = create(:user)
        @drive = create(:drive, updated_by_id: user.id, created_by_id: user.id,
                                organization_id: organization.id)
        @problem = create(:problem, updated_by_id: user.id, created_by_id: user.id,
                                    organization: organization)
        @problem2 = create(:problem, updated_by_id: user.id, created_by_id: user.id,
                                      organization: organization)

        @drives_problem = create(:drives_problem, drive_id: @drive.id, problem_id: @problem.id)
        @drives_problem2 = create(:drives_problem, drive_id: @drive.id, problem_id: @problem2.id)
        create(:test_case, problem_id: @problem.id, marks: 4, updated_by_id: user.id,
          created_by_id: user.id, input: 'hello', output: 'hello')
        create(:test_case, problem_id: @problem2.id, marks: 4, updated_by_id: user.id,
          created_by_id: user.id, input: 'hello', output: 'hello')
      end
      it 'returns all the problems associated with a drive' do
        get :index, params: { id: @drive.id }

        data = json
        expect(data['data'].count).to eq(2)
        expect(data['data'].first['description']).to eq(@problem.description)
        expect(data['message']).to eq('Success')
        expect(response).to have_http_status(200)
      end
    end

    context 'with random id which is not present in database' do
      it 'returns not found error ' do
        get :index, params: { id: Faker::Number }
        data = json

        expect(data['data'].count).to eq(0)
        expect(data['message']).to eq(I18n.t('not_found.message'))
        expect(response).to have_http_status(200)
      end
    end
  end
end
