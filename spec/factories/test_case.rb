# frozen_string_literal: true

FactoryBot.define do
  factory :test_case, class: TestCase do
    association :problem
    input { Faker::Number }
    output { Faker::Number }
    marks { Faker::Number }
  end
end
