# frozen_string_literal: true

FactoryBot.define do
  factory :test_case, class: TestCase do
    association :problem
    input { Faker::Number.digit }
    output { Faker::Number.digit }
    marks { Faker::Number.digit }
  end
end
