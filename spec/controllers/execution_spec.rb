# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExecutionsController, type: :controller do
  describe 'POST #create' do
    context 'with valid params' do
      before do
        stub_request(:post, 'http://65.1.201.245/submissions/?base64_encoded=false&wait=true')
          .with(body: { stdin: 'hello', source_code: "print('hello')", language_id: 71 }.to_json, headers: headers)
          .to_return(status: 200, body: { stdout: 'hello', status: { description: 'Accepted' } }.to_json)

        headers
        post :create, params: { stdin: 'hello', source_code: "print('hello')", language_id: 71 }
      end

      it 'returns output with null error' do
        result = json

        expect(result['data']['stdout']).to eq('hello')
        expect(result['data']['status']).to eq('Accepted')
        expect(result['message']).to eq(I18n.t('success.message'))
        expect(response).to have_http_status(200)
      end
    end

    context 'with invalid params' do
      before do
        stub_request(:post, 'http://65.1.201.245/submissions/?base64_encoded=false&wait=true')
          .with(body: { stdin: 'world', source_code: "print('world';)", language_id: 71 }.to_json, headers: headers)
          .to_return(status: 200, body: { stdout: "SyntaxError: invalid syntax\n",
                                          status: { description: 'Runtime Error' } }.to_json)

        headers
        post :create, params: { stdin: 'world', source_code: "print('world';)", language_id: 71 }
      end

      it 'returns error occured during execution' do
        result = json

        expect(result['data']['stdout']).to eq("SyntaxError: invalid syntax\n")
        expect(result['data']['status']).to eq('Runtime Error')
        expect(result['message']).to eq(I18n.t('success.message'))
        expect(response).to have_http_status(200)
      end
    end
  end
end
