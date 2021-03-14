# frozen_string_literal: true

FactoryBot.define do
  factory :drive, class: Drive do
    name { 'drive1' }
    description { 'Drive details' }
  end
end
