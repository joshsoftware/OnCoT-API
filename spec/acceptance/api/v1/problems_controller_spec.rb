# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Problem' do
  let!(:organization) { create(:organization) }
  let!(:user) { create(:user) }
  let!(:drive) { create(:drive, created_by_id: user.id, updated_by_id: user.id, organization_id: organization.id) }
  let!(:problem) do
    create(:problem, updated_by_id: user.id, created_by_id: user.id,
                     organization: organization)
  end
  let!(:drives_problem) { create(:drives_problem, drive_id: drive.id, problem_id: problem.id) }
  get '/api/v1/drives/:id/problem' do
    parameter :id, 'Drive id'
    context 'with valid params' do
      let!(:id) { drive.id }
      example 'get all problems' do
        do_request
        response = JSON.parse(response_body)
        expect(response['data']['title']).to eq(problem.title)
        expect(response['data']['description']).to eq(problem.description)
        expect(response['message']).to eq('Success')
        expect(status).to eq(200)
      end
    end

    context 'with invalid params' do
      let!(:id) { Faker::Number.number }
      example 'problem not found error' do
        do_request
        expect(status).to eq(404)
      end
    end
  end
end
