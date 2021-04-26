# frozen_string_literal: true

module ActiveSupport
  class TimeWithZone
    def as_json(_options = {})
      strftime('%d-%b-%Y %H:%M:%S')
    end
  end
end
