# frozen_string_literal: true

FactoryBot.define do
  factory :drives_problem, class: DrivesProblem do
    association :drive
    association :problem
  end
end
