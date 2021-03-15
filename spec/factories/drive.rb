# frozen_string_literal: true

FactoryBot.define do
  factory :drive, class: Drive do
    name { 'TestingDrive' }
    description { 'Drive created for RSpec Testing' }
    start_time { Time.current }
    end_time { Time.current + 3.hours }
  end
end
