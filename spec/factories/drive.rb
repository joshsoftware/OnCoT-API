# frozen_string_literal: true

FactoryBot.define do
  factory :drive, class: Drive do
    name { 'TestingDrive' }
    description { 'Drive created for RSpec Testing' }
    start_time { Time.current }
    end_time { Time.current + 3.days }
    organization_id { organization.id }
    created_by_id { organization.id }
    updated_by_id { organization.id }

    before(:create) do |_drive|
      organization = create(:organization)
      # admin = create(:user, :role, name: 'admin')
      # p admin , "------------------"
    end
  end
end
