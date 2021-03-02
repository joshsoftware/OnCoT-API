FactoryBot.define do
  factory :candidate, class: Candidate do
    email { Faker::Internet.email }
  end
end
