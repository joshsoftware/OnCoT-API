# frozen_string_literal: true

FactoryBot.define do
  factory :test_case, class: TestCase do
    association :problem
    input { Faker::Number.number }
    output { Faker::Number.number }
    marks { Faker::Number.number }
  end
end
