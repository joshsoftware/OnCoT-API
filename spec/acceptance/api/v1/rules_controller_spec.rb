# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Rule' do
  let(:organization) { create(:organization) }
  let(:role) { create(:role) }
  let(:user) { create(:user) }
  let(:drive) do
    create(:drive, created_by_id: user.id, updated_by_id: user.id,
                   organization: organization)
  end
  let!(:rule) { create(:rule, drive_id: drive.id) }

  get '/api/v1/drives/:drive_id/rules' do
    parameter :drive_id, 'Drive id'
    context 'with valid params' do
      let!(:drive_id) { drive.id }
      example 'get all rules related to a drive' do
        do_request
        response = JSON.parse(response_body)
        expect(response['data']['rules'].count).to eq(1)
        expect(status).to eq(200)
      end
    end
    context 'with invalid params' do
      let!(:drive_id) { Faker::Number.number }
      example 'rule not found error' do
        do_request
        expect(response_body).to eq(I18n.t('not_found.message'))
        expect(status).to eq(404)
      end
    end
  end
end
