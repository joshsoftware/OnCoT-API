# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubmissionsController, type: :controller do
  describe 'POST #create' do
    context 'with submission_count greater than 0' do
      before do
        header = { 'Accept' => 'application/json' }
        url = 'http://65.1.201.245/submissions/?base64_encoded=false&wait=true'
        stub_request(:post, url)
          .with(body: { stdin: 'hello', expected_output: 'hello', source_code: "print('hello')",
                        language_id: 71 }.to_json, headers: header)
          .to_return(status: 200, body: { stdout: "world\n", status: { description: 'Accepted' } }.to_json)

        stub_request(:post, url)
          .with(body: { stdin: 'world', expected_output: 'world', source_code: "print('hello')",
                        language_id: 71 }.to_json, headers:  header)
          .to_return(status: 200, body: { stdout: "hello\n", status: { description: 'Wrong Answer' } }.to_json)

        organization = create(:organization)
        user = create(:user)
        candidate = create(:candidate)
        problem = create(:problem, updated_by_id: user.id, created_by_id: user.id,
                                   organization: organization)
        create(:test_case, problem_id: problem.id, marks: 4, updated_by_id: user.id,
                           created_by_id: user.id, input: 'hello', output: 'hello')
        create(:test_case, problem_id: problem.id, marks: 4, updated_by_id: user.id,
                           created_by_id: user.id, input: 'world', output: 'world')

        headers
        post :create, params: { source_code: "print('hello')", language_id: 71, candidate_id: candidate.id, id: problem.id,
                                submission_count: 3 }
      end

      it 'creates submission in database' do
        expect(Submission.count).to eq(1)
      end

      it 'returns passed testcases out of total and decremented submission_count' do
        result = json

        expect(result['data']['passed_testcases']).to eq(1)
        expect(result['data']['total_testcases']).to eq(2)
        expect(result['data']['submission_count']).to eq(2)
        expect(result['message']).to eq(I18n.t('success.message'))
        expect(response).to have_http_status(200)
      end
    end

    context 'with submission_count as 0' do
      it 'returns submission limit exceeded message' do
        headers
        post :create, params: { source_code: "print('world')", language_id: 71, candidate_id: 1, id: 7, submission_count: 0 }

        expect(response.body).to eq('submission limit exceeded')
      end
    end
  end
end
