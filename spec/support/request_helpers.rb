# frozen_string_literal: true

module Requests
  module JsonHelpers
    def json
      @json ||= JSON.parse(response.body)
    end
  end

  module HeaderHelpers
    def headers
      headers ||= request.headers.merge!('CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json')
    end
  end
end
