# frozen_string_literal: true

FactoryBot.define do
  factory :drives_problem, class: DrivesProblem do
    created_at { Time.now }
    updated_at { Time.now }
  end
end
