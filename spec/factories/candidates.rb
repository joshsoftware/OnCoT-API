# frozen_string_literal: true

# == Schema Information
#
# Table name: candidates
#
#  id                  :bigint           not null, primary key
#  first_name          :string
#  last_name           :string
#  email               :string
#  is_profile_complete :boolean
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  mobile_number       :string
#
FactoryBot.define do
  factory :candidate, class: Candidate do
    first_name { Faker::Name.name }
    last_name { Faker::Name.name  }
    email { Faker::Internet.email }
    mobile_number { Faker::PhoneNumber }
    is_profile_complete { true }
  end
end
