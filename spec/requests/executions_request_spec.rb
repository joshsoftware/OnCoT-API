require 'rails_helper'

RSpec.describe "Executions", type: :request do
  let(:token) { "8d0c8819-0346-45df-b089-94ac3cf868ed" }
  describe "POST #submission_token" do
    before do
      params={
        "language_id": 71,
        "source_code": "print(\"\Hello World\")"
      }
      post "/token",  params:params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    end    
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end    
    it "JSON body response contains expected token attributes" do
      expect(response.body).not_to eq("null")
    end
  end

  describe "GET /submission/:token" do
    before { get "/submission/#{token}" }
    it "returns status code 200" do
      expect(response).to have_http_status(200)
    end

    it "JSON body response contains expected submission attributes" do
      body = JSON.parse(response.body)
      expect(body.keys).to match_array(["compile_output", "memory", "message", "status", "stderr", "stdout", "time", "token"])
    end
  end
end
