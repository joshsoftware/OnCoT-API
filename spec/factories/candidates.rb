FactoryBot.define do
  factory :candidate, class: Candidate do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    mobile_number { Faker::PhoneNumber }
  end
end
