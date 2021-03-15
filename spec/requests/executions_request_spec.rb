require 'rails_helper'
require 'spec_helper'

RSpec.describe 'Executions', type: :request do
  let(:token) { '8d0c8819-0346-45df-b089-94ac3cf868ed' }
  describe 'POST #submission_token' do
    before(:each) do
      stub_request(:post, 'http://65.1.201.245/submissions/?base64_encoded=false&wait=false')
        .with(
          body: '{"language_id":71,"source_code":"print(\\"Hello World\\")","controller":"executions","action":"submission_token","execution":{"language_id":71,"source_code":"print(\\"Hello World\\")"}}',
          headers: {
            'Connection' => 'close',
            'Content-Type' => 'application/json',
            'Host' => '65.1.201.245',
            'User-Agent' => 'http.rb/4.4.1'
          }
        )
        .to_return(status: 200, "body": '{"token":"fc77ad79-02f3-44ac-877f-bc10154466b2"}', headers: {})
      params = {
        "language_id": 71,
        "source_code": "print(\"\Hello World\")"
      }
      post '/executions/submission_token', params: params.to_json,
                                           headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    end
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
    it 'JSON body response contains expected token attributes' do
      expect(response.body).not_to eq('null')
    end
  end

  describe 'GET /executions/:token/submission_status' do
    before(:each) do
      stub_request(:get, 'http://65.1.201.245/submissions/8d0c8819-0346-45df-b089-94ac3cf868ed')
        .with(
          headers: {
            'Connection' => 'close',
            'Host' => '65.1.201.245',
            'User-Agent' => 'http.rb/4.4.1'
          }
        )
        .to_return(status: 200, "body":
          "{\"stdout\":\"Hello World\\n\",\"time\":\"0.287\",\"memory\":7908,\"stderr\":null,
          \"token\":\"8d0c8819-0346-45df-b089-94ac3cf868ed\",\"compile_output\":null,
          \"message\":null,\"status\":{\"id\":3,\"description\":\"Accepted\"}}", headers: {})
    end
    before { get "/executions/#{token}/submission_status" }
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'JSON body response contains expected submission attributes' do
      body = JSON.parse(response.body)
      expect(body['data'].keys).to match_array(%w[compile_output memory message status stderr stdout time
                                                  token])
    end
  end
end
