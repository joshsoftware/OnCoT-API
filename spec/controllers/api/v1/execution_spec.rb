# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ExecutionsController, type: :controller do
  describe 'POST #submission_token' do
    context 'with valid params' do
      before do
        stub_request(:post, 'http://65.1.201.245/submissions/?base64_encoded=false&wait=false')
          .with(body: { source_code: "print('hello')",
                        language_id: 71 }.to_json, headers: headers)
          .to_return(status: 200, body: { token: 'token123' }.to_json)

        headers
        post :submission_token, params: { source_code: "print('hello')", language_id: 71 }
      end
      it 'returns token' do
        result = json

        expect(result['data']['token']).to eq('token123')
        expect(result['message']).to eq(I18n.t('success.message'))
        expect(response).to have_http_status(200)
      end
    end

    describe 'GET #submission_status' do
      before do
        stub_request(:get, 'http://65.1.201.245/submissions/token123')
          .to_return(status: 200, body: { stdout: 'hello', status: { description: 'Accepted' } }.to_json)

        get :submission_status, params: { id: 'token123' }
      end

      it 'returns submission status' do
        result = json

        expect(result['data']['stdout']).to eq('hello')
        expect(result['data']['status']['description']).to eq('Accepted')
        expect(result['message']).to eq(I18n.t('success.message'))
        expect(response).to have_http_status(200)
      end
    end
  end
end
