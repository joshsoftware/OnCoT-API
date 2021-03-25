# frozen_string_literal: true

FactoryBot.define do
  factory :submission, class: Submission do
    answer { Faker::Lorem.word }
  end
end
