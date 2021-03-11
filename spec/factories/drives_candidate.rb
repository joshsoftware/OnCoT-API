# frozen_string_literal: true

FactoryBot.define do
  factory :drives_candidate, class: DrivesCandidate do
    created_at { Time.now }
    updated_at { Time.now }
    token { '123456' }
  end
end
