# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Admin::TestcasesController, type: :controller do
  let(:organization) { create(:organization) }
  let(:role) { create(:role) }
  let(:user) { create(:user) }
  let(:problem) do
    create(:problem, created_by_id: user.id,
                     updated_by_id: user.id, organization: organization)
  end
  let(:test_case) do
    create(:test_case, problem_id: problem.id, created_by_id: user.id,
                       updated_by_id: user.id)
  end

  describe 'POST #CREATE' do
    context 'with valid params' do
      it 'Creates the testcase' do
        post :create,
             params: { input: Faker::Number.digit, output: Faker::Number.digit, marks: Faker::Number.digit,
                       created_by_id: user.id, updated_by_id: user.id, problem_id: problem.id }

        testcase = json

        expect(testcase['data']['testcase']['input']).to eq(request.params['input'])
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'fails Create action as not passing problem id' do
        post :create,
             params: { input: Faker::Number.digit, output: Faker::Number.digit,
                       marks: Faker::Number.digit, created_by_id: user.id, updated_by_id: user.id }

        testcase = json

        expect(testcase['problem'][0]).to eq('must exist')
        expect(response).to have_http_status(400)
      end
    end
  end

  describe 'PUT #UPDATE' do
    context 'with valid params' do
      it 'Updates the testcase' do
        expect do
          put :update,
              params: { id: test_case.id, input: '201', output: Faker::Number.digit,
                        marks: Faker::Number.digit, created_by_id: user.id, updated_by_id: user.id,
                        problem_id: problem.id }
        end.to change { test_case.reload.input }.from(test_case.input).to('201')

        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'returns the not found error as passing random id which is not present in database' do
        patch :update, params: { id: Faker::Number.number }

        expect(response.body).to eq('Record not found')
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'GET #SHOW' do
    context 'with valid params' do
      it 'shows a testcase' do
        get :show, params: { id: test_case.id }

        data = json
        expect(data['data']['testcase']['input']).to eq(test_case.input)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'returns the not found error as passing random id which is not present in database' do
        get :show, params: { id: Faker::Number.number(digits: 5) }

        expect(response.body).to eq('Record not found')
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'GET #INDEX' do
    it 'shows all testcases' do
      get :index, params: { problem_id: problem.id }

      data = json
      expect(data['data']['testcases'].count).to eq(TestCase.count)
      expect(response).to have_http_status(:ok)
    end
  end
end
