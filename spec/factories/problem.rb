# frozen_string_literal: true

FactoryBot.define do
  factory :problem, class: Problem do
    association :organization
    title { 'problem' }
    description { 'Add 2 numbers' }
    submission_count { 4 }
    time_in_minutes { 3600 }
  end
end
