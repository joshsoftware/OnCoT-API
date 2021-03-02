FactoryBot.define do
  factory :drive, class: Drive do
    name { 'drive' }
    description { 'drive description' }
    start_time { 1.days.from_now }
    end_time { 10.days.from_now }
  end
end
