# frozen_string_literal: true

FactoryBot.define do
  factory :test_case_result, class: TestCaseResult do
    is_passed { true }
  end
end
