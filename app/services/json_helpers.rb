# frozen_string_literal: true

module JsonHelpers
  def json(response)
    JSON.parse(response.body)
  end
end
