# frozen_string_literal: true

module Requests
  module JsonHelpers
    def json_response(response)
      @json_response ||= JSON.parse(response.body)
    end
  end
end
