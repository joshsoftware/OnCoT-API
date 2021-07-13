# frozen_string_literal: true

require 'http'

class ParamAiApi
#   BASE_URI = ENV['PARAMS_AI_URL']

  def initialize(params)
    @params = params
    @headers = { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
  end

  def post
    response = HTTP.post(ENV['PARAMS_AI_URL'], headers: @headers, body: @params.to_json)
    JSON.parse(response.body)
  end
end
