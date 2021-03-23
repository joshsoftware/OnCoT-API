# frozen_string_literal: true

FactoryBot.define do
  factory :admin, class: User do
    first_name { Faker::Name.name }
    last_name { Faker::Name.name  }
    email { Faker::Internet.email }
    password { 'josh123' }

    before(:create) do |user|
      user.organization = create(:organization)
      user.role = create(:role, name: 'admin')
    end
  end
end
