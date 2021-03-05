FactoryBot.define do
  factory :problem, class: Problem do
    association :organization
    title { 'problem' }
    description { 'Add 2 numbers' }
  end
end
