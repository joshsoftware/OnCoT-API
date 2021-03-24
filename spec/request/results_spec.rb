require 'rails_helper'

RSpec.describe ResultsController, type: :controller do
  describe 'GET show' do
    before(:each) do
      @organization = create(:organization)
      @user = create(:user)
      @candidate = create(:candidate)
      @problem = create(:problem, updated_by_id: @user.id, created_by_id: @user.id,
                                  organization: @organization)
      @test_case1 = create(:test_case, problem_id: @problem.id, marks: 4, updated_by_id: @user.id,
                                       created_by_id: @user.id)
      @test_case2 = create(:test_case, problem_id: @problem.id, marks: 4, updated_by_id: @user.id,
                                       created_by_id: @user.id)
      @submission1 = create(:submission, problem_id: @problem.id, candidate_id: @candidate.id)
      @submission2 = create(:submission, problem_id: @problem.id, candidate_id: @candidate.id)
      @test_case_result1 = create(:test_case_result, test_case_id: @test_case1.id, submission_id: @submission1.id,
                                                     is_passed: true)
      @test_case_result2 = create(:test_case_result, test_case_id: @test_case2.id, submission_id: @submission1.id,
                                                     is_passed: true)
      @test_case_result3 = create(:test_case_result, test_case_id: @test_case1.id, submission_id: @submission2.id,
                                                     is_passed: true)
      @test_case_result4 = create(:test_case_result, test_case_id: @test_case2.id, submission_id: @submission2.id,
                                                     is_passed: false)
    end
    context 'with valid params' do
      it 'returns the maximum marks obtained' do
        get :show, params: { id: @problem.id, candidate_id: @candidate.id }

        expect(response.body).to eq({ data: 8, message: 'Success' }.to_json)
        expect(response).to have_http_status(200)
      end
    end

    context 'with invalid params' do
      it 'returns "not found" as submissions not actually present' do
        get :show, params: { id: Faker::Number, candidate_id: Faker::Number }

        expect(response.body).to eq(I18n.t('not_found.message'))
      end
    end
  end
end
