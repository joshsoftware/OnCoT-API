# frozen_string_literal: true

module JsonHelpers
  def json(response)
    @json ||= JSON.parse(response.body)
  end
end