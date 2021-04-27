# frozen_string_literal: true

require 'http'

class JudgeZeroApi
  BASE_URI = 'http://roupi.xyz'

  def initialize(params = {})
    @params = params
    @headers = { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
  end

  def get(path)
    response = HTTP.get("#{BASE_URI}#{path}")
    JSON.parse(response.body)
  end

  def post(path)
    response = HTTP.post("#{BASE_URI}#{path}", headers: @headers, body: @params.to_json)
    JSON.parse(response.body)
  end
end
