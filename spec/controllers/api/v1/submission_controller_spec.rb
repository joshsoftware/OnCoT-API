# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::SubmissionsController, type: :controller do
  describe 'POST #create' do
    context 'with submission_count greater than 0' do
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

        organization = create(:organization)
        user = create(:user)
        candidate = create(:candidate)
        drive = create(:drive, updated_by_id: user.id, organization: organization,
                               created_by_id: user.id)
        create(:drives_candidate, candidate_id: candidate.id, drive_id: drive.id)
        problem = create(:problem, updated_by_id: user.id, created_by_id: user.id,
                                   organization: organization, submission_count: 1)
        create(:test_case, problem_id: problem.id, marks: 4, updated_by_id: user.id,
                           created_by_id: user.id, input: 'hello', output: 'hello')
        create(:test_case, problem_id: problem.id, marks: 4, updated_by_id: user.id,
                           created_by_id: user.id, input: 'world', output: 'world')

        headers
        post :create,
             params: { source_code: "print('hello')", language_id: 71, candidate_id: candidate.id, id: problem.id,
                       drive_id: drive.id }
      end

      it 'creates submission in database' do
        expect(Submission.count).to eq(1)
      end

      it 'returns passed testcases out of total and decremented submission_count' do
        result = json

        expect(result['data']['passed_testcases']).to eq(1)
        expect(result['data']['total_testcases']).to eq(2)
        expect(result['message']).to eq(I18n.t('success.message'))
        expect(response).to have_http_status(200)
      end
    end

    context 'when candiadte submissions equal to submission_count are present' do
      before do
        organization = create(:organization)
        user = create(:user)
        candidate = create(:candidate)
        drive = create(:drive, updated_by_id: user.id, organization: organization,
                               created_by_id: user.id)
        drives_candidate = create(:drives_candidate, candidate_id: candidate.id, drive_id: drive.id)
        problem = create(:problem, updated_by_id: user.id, created_by_id: user.id,
                                   organization: organization, submission_count: 1)
        create(:submission, drives_candidate_id: drives_candidate.id, problem_id: problem.id)

        headers
        post :create,
             params: { source_code: "print('world')", language_id: 71, candidate_id: candidate.id, id: problem.id,
                       drive_id: drive.id }
      end
      it 'returns submission limit exceeded message' do
        expect(response.body).to eq(I18n.t('submission.limit_exceed.message'))
      end
    end
  end
end
