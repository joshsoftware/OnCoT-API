# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ResultsController, type: :controller do
  describe 'GET #index' do
    before do
      organization = create(:organization)
      user = create(:user)
      candidate1 = create(:candidate)
      candidate2 = create(:candidate)
      @drive = create(:drive, updated_by_id: user.id, created_by_id: user.id,
                              organization: organization)
      @drives_candidate1 = create(:drives_candidate, drive_id: @drive.id, candidate_id: candidate1.id, score: 8,
                                                     completed_at: Time.now.iso8601, end_time: Time.now.iso8601)
      @drives_candidate2 = create(:drives_candidate, drive_id: @drive.id, candidate_id: candidate2.id, score: 10,
                                                     end_time: Time.now.iso8601)
    end

    it 'returns candidate_id, scores, end_times of a drive' do
      get :index, params: { drife_id: @drive.id }

      result = json
      expect(result['data'][0]['candidate_id']).to eq(22)
      expect(result['data'][0]['score']).to eq(8)
      expect(result['data'][0]['end_times']).to eq(@drives_candidate1.completed_at.iso8601.to_s)
      expect(result['data'][1]['candidate_id']).to eq(23)
      expect(result['data'][1]['score']).to eq(10)
      expect(result['data'][1]['end_times']).to eq(@drives_candidate2.end_time.iso8601.to_s)
      expect(result['message']).to eq(I18n.t('success.message'))
      expect(response).to have_http_status(200)
    end
  end
end