# frozen_string_literal: true

FactoryBot.define do
  factory :rule, class: Rule do
    type_name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
  end
end
