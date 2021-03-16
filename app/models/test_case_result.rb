# frozen_string_literal: true

class TestCaseResult < ApplicationRecord
  belongs_to :submission
  belongs_to :test_case
end
