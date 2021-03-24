FactoryBot.define do
  factory :submission, class: Submission do
    association :problem
    answer { Faker::Lorem.word }
  end
end
