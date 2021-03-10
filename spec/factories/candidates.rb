# frozen_string_literal: true

FactoryBot.define do
  factory :candidate, class: Candidate do
    email { Faker::Internet.email }
    first_name { 'Samruddhi' }
    last_name { 'Deshpande' }
    is_profile_complete { 'Yes' }
    drive_id { 9 }
  end
end
