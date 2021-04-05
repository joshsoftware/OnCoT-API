# frozen_string_literal: true

FactoryBot.define do
  factory :role, class: Role do
    name { 'Admin' }
  end
end
