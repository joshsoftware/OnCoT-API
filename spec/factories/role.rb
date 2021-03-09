# frozen_string_literal: true

FactoryBot.define do
  factory :role, class: Role do
    type { 'admin' }
    created_at { Time.now }
    updated_at { Time.now }
  end
end
