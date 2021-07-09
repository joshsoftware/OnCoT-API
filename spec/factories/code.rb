# frozen_string_literal: true

FactoryBot.define do
  factory :code, class: Code do
    answer { Faker::Lorem.sentence }
    lang_code { Faker::Number.digit }
  end
end
