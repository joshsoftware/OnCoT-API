# frozen_string_literal: true

require 'rollbar'

Rollbar.configure do |config|
  config.access_token = Figaro.env.ROLLBAR_TOKEN
end
