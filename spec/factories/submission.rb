# frozen_string_literal: true

FactoryBot.define do
  factory :submission, class: Submission do
    association :drives_candidate
    association :problem
    answer { Faker::Lorem.word }
  end
end
