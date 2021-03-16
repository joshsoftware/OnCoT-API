# frozen_string_literal: true

require 'http'

class JudgeZeroApi
  BASE_URI = ENV['BASE_URI']

  def initialize(params = {}, headers = {})
    @params = params
    @headers = headers
  end

  def get(path)
    response = HTTP.get("#{BASE_URI}#{path}")
  end

  def post(path)
    HTTP.post("#{BASE_URI}#{path}", headers: @headers, body: @params.to_json)
  end
end
