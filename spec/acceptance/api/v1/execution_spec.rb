# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Execution' do
  post '/api/v1/executions/submission_token' do
    parameter :source_code, 'Source code'
    parameter :language_id, 'Language id'
    before do
      stub_request(:post, "#{ENV['JUDGE_ZERO_BASE_URI']}/submissions/?base64_encoded=false&wait=false")
        .with(
          body: "{\"source_code\":\"print('hello')\",\"language_id\":\"71\",\"stdin\":null,\"callback_url\":\"http://localhost:3000/api/v1//executions/submission_result?room=\"}",
          headers: { 'Content-Type' => 'application/json' }
        )
        .to_return(status: 200, body: { token: 'token123' }.to_json)
    end
    let!(:source_code) { "print('hello')" }
    let!(:language_id) { 71 }
    example 'API to return submission token' do
      do_request
      response = JSON.parse(response_body)
      expect(response['data']['token']).to eq('token123')
      expect(response['message']).to eq(I18n.t('success.message'))
      expect(status).to eq(200)
    end
  end

  get '/api/v1/executions/:id/submission_status' do
    parameter :id, 'token'
    before do
      stub_request(:get, "#{ENV['JUDGE_ZERO_BASE_URI']}/submissions/token123")
        .to_return(status: 200, body: { stdout: 'hello', status: { description: 'Accepted' } }.to_json)
    end
    let!(:id) { 'token123' }
    example 'get submission status' do
      do_request
      response = JSON.parse(response_body)
      expect(response['data']['stdout']).to eq('hello')
      expect(response['data']['status']['description']).to eq('Accepted')
      expect(response['message']).to eq(I18n.t('success.message'))
      expect(status).to eq(200)
    end
  end
end
