# frozen_string_literal: true

module Requests
  module ScenarioHelpers
    def yet_to_start?
      return true if start_date > Time.current
    end

    def ended?
      return true if end_date < Time.current
    end

    def ongoing?
      return true if start_date < Time.current && Time.current < end_date
    end
  end
end
