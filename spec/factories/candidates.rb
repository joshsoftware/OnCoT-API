# frozen_string_literal: true

FactoryBot.define do
  factory :candidate, class: Candidate do
    first_name { Faker::Name.name }
    last_name { Faker::Name.name  }
    email { Faker::Internet.email }
    mobile_number { Faker::PhoneNumber }
    is_profile_complete { true }
  end
end
