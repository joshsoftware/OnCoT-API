FactoryBot.define do
  factory :drive, class: Drive do
    name { 'drive1' }
    description { 'Drive details' }
    created_at { Time.now }
    updated_at { Time.now }
  end
end
