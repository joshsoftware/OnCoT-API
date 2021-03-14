# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Drives', type: :request do
  describe 'GET show' do
    context 'Success' do
      let(:token) { '74c5a8ae66b2265a1a2cce75c84de8d6b75fe52c' }
      before { get "/drives/#{token}" }
      it 'returns success' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'Failure' do
      let(:token) { '74c5a8ae66b2265a1a2cce75c84de8d6b75fe52' }
      before { get "/drives/#{token}" }
      it 'returns :not_found' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
