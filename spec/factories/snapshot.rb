# frozen_string_literal: true

FactoryBot.define do
  factory :snapshot, class: Snapshot do
    association :drives_candidate
    image_url { Faker::Internet.url }
  end
end
