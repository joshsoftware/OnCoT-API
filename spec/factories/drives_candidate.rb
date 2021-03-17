# frozen_string_literal: true

FactoryBot.define do
  factory :drives_candidate, class: DrivesCandidate do
    association :drive
    association :candidate
    token { '123456' }
  end
end
