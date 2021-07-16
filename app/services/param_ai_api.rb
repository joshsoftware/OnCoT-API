# frozen_string_literal: true

require 'http'

class ParamAiApi
  def initialize(params)
    @params = params
    @headers = { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
  end

  def post
    response = HTTP.post(ENV['PARAMS_AI_URL'], headers: @headers, body: @params.to_json)
    response.status
  end
end
