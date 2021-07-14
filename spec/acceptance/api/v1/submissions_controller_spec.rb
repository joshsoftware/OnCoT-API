# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Submission' do
  post '/api/v1/submissions' do
    context 'with submission_count greater than 0' do
      parameter :source_code
      parameter :language_id
      parameter :candidate_id
      parameter :id, 'Problem id'
      parameter :drive_id
      parameter :token
      before  do
        url = 'http://65.1.201.245/submissions/?base64_encoded=false&wait=true'
        stub_request(:post, url)
          .with(body: { stdin: 'hello', expected_output: 'hello', source_code: "print('hello')",
                        language_id: 71 }.to_json, headers: headers)
          .to_return(status: 200, body: { stdout: 'hello', status: { description: 'Accepted' } }.to_json)

        stub_request(:post, url)
          .with(body: { stdin: 'world', expected_output: 'world', source_code: "print('hello')",
                        language_id: 71 }.to_json, headers: headers)
          .to_return(status: 200, body: { stdout: 'hello', status: { description: 'Wrong Answer' } }.to_json)
        headers
      end
      let!(:organization) { create(:organization) }
      let!(:user) { create(:user) }
      let!(:candidate) { create(:candidate) }
      let!(:drive) do
        create(:drive, updated_by_id: user.id, organization: organization,
                       created_by_id: user.id)
      end
      let!(:drives_candidate) do
        create(:drives_candidate, candidate_id: candidate.id, drive_id: drive.id, end_time: DateTime.current + 1.hours,
                                  drive_start_time: DateTime.current, drive_end_time: DateTime.current + 1.hours)
      end
      let!(:problem) do
        create(:problem, updated_by_id: user.id, created_by_id: user.id,
                         organization: organization, submission_count: 3)
      end
      let!(:test_case1) do
        create(:test_case, problem_id: problem.id, marks: 4, updated_by_id: user.id,
                           created_by_id: user.id, input: 'hello', output: 'hello')
      end
      let!(:test_case2) do
        create(:test_case, problem_id: problem.id, marks: 4, updated_by_id: user.id,
                           created_by_id: user.id, input: 'world', output: 'world')
      end

      let!(:source_code) { "print('hello')" }
      let!(:language_id) { 71 }
      let!(:candidate_id) { candidate.id }
      let!(:id) { problem.id }
      let!(:drive_id) { drive.id }
      let!(:token) { drives_candidate.token }

      example 'API to create submission in database' do
        do_request
        expect(Submission.count).to eq(1)
      end

      example 'API to return passed testcases out of total and decremented submission_count' do
        do_request
        response = JSON.parse(response_body)
        expect(response['data']['status']).to eq('processing')
        expect(response['message']).to eq(I18n.t('success.message'))
        expect(status).to eq(200)
      end
    end
  end
end
