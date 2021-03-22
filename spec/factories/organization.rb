FactoryBot.define do
  factory :organization, class: Organization do
    name { 'Josh Software' }
    description { 'Software Company' }
    email { Faker::Internet.email }
    contact_number { Faker::PhoneNumber }
  end
end
