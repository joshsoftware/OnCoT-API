# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ResultsController, type: :controller do
  describe 'GET #index' do
    it 'returns candidate_id, scores, end_times of a drive' do
      get :index, params: { drife_id: @drive1.id }

      result = json
      expect(result['data'][0]['candidate_id']).to eq(6)
      expect(result['data'][0]['score']).to eq(9)
      expect(result['data'][0]['end_times']).to eq()
      expect(result['data'][1]['candidate_id']).to eq(7)
      expect(result['data'][1]['score']).to eq(5)
      expect(result['data'][1]['end_times']).to eq(7)
      expect(result['message']).to eq(I18n.t('success.message'))
      expect(response).to have_http_status(200)
    end
  end
end

