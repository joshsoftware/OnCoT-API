# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Admin::TestCasesController, type: :controller do
  let(:organization) { create(:organization) }
  let(:role) { create(:role) }
  let(:user) { create(:user) }
  let(:problem) do
    create(:problem, created_by_id: user.id,
                     updated_by_id: user.id, organization: organization)
  end
  let!(:test_case) do
    create(:test_case, problem_id: problem.id, created_by_id: user.id,
                       updated_by_id: user.id)
  end

  describe 'POST #CREATE' do
    context 'When user is logged in' do
      before do
        auth_tokens_for_user(user)
      end

      context 'with valid params' do
        it 'Creates the test_case' do
          post :create,
               params: { input: Faker::Number.digit, output: Faker::Number.digit, marks: Faker::Number.digit,
                         created_by_id: user.id, updated_by_id: user.id, problem_id: problem.id }

          test_case = json

          expect(test_case['data']['test_case']['input']).to eq(request.params['input'])
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with invalid params' do
        it 'fails Create action as not passing problem id' do
          post :create,
               params: { input: Faker::Number.digit, output: Faker::Number.digit,
                         marks: Faker::Number.digit, created_by_id: user.id, updated_by_id: user.id }

          test_case = json

          expect(test_case['problem'][0]).to eq('must exist')
          expect(response).to have_http_status(400)
        end
      end
    end
    context 'When user is not logged in' do
      it ' ask for login ' do
        post :create,
             params: { input: Faker::Number.digit, output: Faker::Number.digit, marks: Faker::Number.digit,
                       created_by_id: user.id, updated_by_id: user.id, problem_id: problem.id }

        test_case = json

        expect(test_case['errors'].first).to eq('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'PUT #UPDATE' do
    context 'When user is logged in' do
      before do
        auth_tokens_for_user(user)
      end

      context 'with valid params' do
        it 'Updates the test_case' do
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

          expect(response.body).to eq(I18n.t('not_found.message'))
          expect(response).to have_http_status(404)
        end
      end
    end
    context 'When user is not logged in' do
      it ' ask for login ' do
        put :update,
            params: { id: test_case.id, input: Faker::Number.digit, output: Faker::Number.digit, marks: Faker::Number.digit,
                      created_by_id: user.id, updated_by_id: user.id, problem_id: problem.id }

        test_case = json

        expect(test_case['errors'].first).to eq('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'GET #SHOW' do
    context 'When user is logged in' do
      before do
        auth_tokens_for_user(user)
      end

      context 'with valid params' do
        it 'shows a test_case' do
          get :show, params: { id: test_case.id }

          data = json
          expect(data['data']['test_case']['input']).to eq(test_case.input)
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with invalid params' do
        it 'returns the not found error as passing random id which is not present in database' do
          get :show, params: { id: Faker::Number.number(digits: 5) }

          expect(response.body).to eq(I18n.t('not_found.message'))
          expect(response).to have_http_status(404)
        end
      end
    end
    context 'When user is not logged in' do
      it ' ask for login ' do
        get :show, params: { id: test_case.id }

        test_case = json

        expect(test_case['errors'].first).to eq('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'GET #INDEX' do
    context 'When user is logged in' do
      before do
        auth_tokens_for_user(user)
      end

      it 'shows all test_cases' do
        get :index, params: { problem_id: problem.id }

        test_cases = json
        expect(test_cases['data']['test_cases'].count).to eq(1)
        expect(response).to have_http_status(:ok)
      end
    end
    context 'When user is logged in' do
      it ' ask for login ' do
        get :index, params: { problem_id: problem.id }

        test_cases = json

        expect(test_cases['errors'].first).to eq('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(401)
      end
    end
  end
end
