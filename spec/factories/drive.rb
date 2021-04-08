# frozen_string_literal: true

FactoryBot.define do
  factory :drive, class: Drive do
    name { 'TestingDrive' }
    description { 'Drive created for RSpec Testing' }
    start_time { DateTime.now.localtime + 1.hours }
    end_time { DateTime.now.localtime + 3.hours }
    duration { end_time - start_time }
  end
end
