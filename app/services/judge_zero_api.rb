# frozen_string_literal: true

require 'http'

class JudgeZeroApi
  BASE_URI = ENV['BASE_URI']
  HEADERS = { "Content-Type": 'application/json' }.freeze
  def initialize(params = {}, _headers = {})
    @params = params
  end

  def get(path)
    response = HTTP.get("#{BASE_URI}#{path}")
  end

  def post(path)
    HTTP.post("#{BASE_URI}#{path}", headers: HEADERS, body: @params.to_json)
  end
end
