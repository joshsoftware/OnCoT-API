# frozen_string_literal: true

FactoryBot.define do
  factory :snapshot, class: Snapshot do
    url { Faker::Internet.url }
  end
end
