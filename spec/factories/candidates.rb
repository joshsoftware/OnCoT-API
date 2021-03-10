FactoryBot.define do
  factory :candidate, class: Candidate do
    email { Faker::Internet.email }
    first_name { 'Samruddhi' }
    last_name { 'Deshpande' }
 
  end
end
