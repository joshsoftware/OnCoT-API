# frozen_string_literal: true

module Requests
  module JsonHelpers
    def parse_json(obj)
      data = JSON.parse(obj)

      data['data']
    end
  end
end
