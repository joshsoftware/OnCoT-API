# frozen_string_literal: true

require 'http'

class JudgeZeroApi
  BASE_URI = 'http://65.1.201.245'

  def initialize(params = {})
    @params = params
  end

  def get(path)
    response = HTTP.get("#{BASE_URI}#{path}")
    response = JSON.parse response
  end

  def post(path)
    HTTP.post("#{BASE_URI}#{path}", params: @params)
  end
end
