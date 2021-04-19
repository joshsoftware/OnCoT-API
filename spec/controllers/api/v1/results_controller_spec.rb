# frozen_string_literal: true

require 'rails_helper'
require 'csv'
RSpec.describe Api::V1::ResultsController, type: :controller do
  describe 'GET #index' do
    before do
      organization = create(:organization)
      user = create(:user)
      candidate1 = create(:candidate, first_name: 'Kiran', last_name: 'Patil', email: 'kiran@gmail.com')
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
      expect(result['data'][0]['candidate_id']).to eq(@drives_candidate1.id)
      expect(result['data'][0]['first_name']).to eq('Kiran')
      expect(result['data'][0]['last_name']).to eq('Patil')
      expect(result['data'][0]['email']).to eq('kiran@gmail.com')
      expect(result['data'][0]['score']).to eq(8)
      expect(result['data'][0]['end_times']).to eq(@drives_candidate1.completed_at.iso8601.to_s)
      expect(result['data'][1]['candidate_id']).to eq(@drives_candidate2.id)
      expect(result['data'][1]['score']).to eq(10)
      expect(result['message']).to eq(I18n.t('success.message'))
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET #csv_result' do
    before do
      organization = create(:organization)
      user = create(:user)
      candidate = create(:candidate, first_name: 'Kiran', last_name: 'Patil', email: 'kiran@gmail.com')
      @drive = create(:drive, updated_by_id: user.id, created_by_id: user.id,
                              organization: organization)
      create(:drives_candidate, drive_id: @drive.id, candidate_id: candidate.id, score: 8)
    end

    it 'returns candidate result data in csv' do
      get :csv_result, params: { drife_id: @drive.id }, format: :csv

      expected_row = [['Email', 'kiran@gmail.com'], %w[First_name Kiran], %w[Last_name Patil], %w[Score 8]]
      table = CSV.parse(File.read('result_file.csv'), headers: true)
      csv_row = table.by_row[0]
      expect(expected_row).to match_array(csv_row)
    end
  end
end
