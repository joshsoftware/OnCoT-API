# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Drive' do
  let(:organization) { create(:organization) }
  let(:role) { create(:role) }
  let(:user) { create(:user, role_id: role.id) }
  let(:drive1) do
    create(:drive, updated_by_id: user.id, created_by_id: user.id,
                   organization: organization, start_time: DateTime.current + 1.hours,
                   end_time: DateTime.current + 3.hours, duration: 10_800)
  end
  let(:drive2) do
    create(:drive, updated_by_id: user.id, created_by_id: user.id,
                   organization: organization, start_time: DateTime.current - 1.hours,
                   end_time: DateTime.current + 1.hours, duration: 10_800)
  end
  let(:drive3) do
    create(:drive, updated_by_id: user.id, created_by_id: user.id,
                   organization: organization, start_time: DateTime.current - 3.hours,
                   end_time: DateTime.current - 1.hours, duration: 10_800)
  end
  let(:candidate) { create(:candidate) }
  let(:drives_candidate1) { create(:drives_candidate, drive_id: drive1.id, candidate_id: candidate.id) }
  let(:drives_candidate2) { create(:drives_candidate, drive_id: drive2.id, candidate_id: candidate.id) }
  let(:drives_candidate3) { create(:drives_candidate, drive_id: drive3.id, candidate_id: candidate.id) }

  get '/api/v1/drives/:id' do
    parameter :id, 'DrivesCandidate token'
    context 'with valid params' do
      let!(:id) { drives_candidate1.token }
      example 'drive details API' do
        do_request
        response = JSON.parse(response_body)
        expect(response['data']['drive']['name']).to eq(drive1.name)
        expect(status).to eq(200)
      end
    end

    context 'with invalid params' do
      let!(:id) { Faker::Number.number }
      example 'drive not found' do
        do_request
        expect(status).to eq(404)
      end
    end
  end

  get '/api/v1/drives/:id/drive_time_left' do
    parameter :id, 'Drive id'
    context 'Drive is yet to start.' do
      let!(:id) { drives_candidate1.token }
      example 'API to return time left to start drive' do
        do_request
        response = JSON.parse(response_body)
        expect(response['message']).to eq(I18n.t('drive.yet_to_start'))
        expect(response['data']['is_live']).to eq(true)
        expect(status).to eq(200)
      end
    end
    context 'Drive has already started' do
      let!(:id) { drives_candidate2.token }
      example 'drive already started API' do
        do_request
        response = JSON.parse(response_body)
        expect(response['message']).to eq(I18n.t('drive.started'))
        expect(response['data']['is_live']).to eq(true)
        expect(status).to eq(200)
      end
    end

    context 'Drive has already ended.' do
      let!(:id) { drives_candidate3.token }
      example 'drive completed API' do
        do_request
        response = JSON.parse(response_body)
        expect(response['message']).to eq(I18n.t('drive.ended'))
        expect(response['data']['is_live']).to eq(false)
        expect(status).to eq(200)
      end
    end
  end
end
