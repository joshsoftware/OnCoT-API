FactoryBot.define do
  factory :reviewer, class: User do
    
    first_name { 'Neha' }
    last_name { 'Vyas' }
    email { Faker::Internet.email }
    password { 'josh123'}
    
    before(:create) do |user|
      user.organization = create(:organization)
      user.role = create(:role, name: 'reviewer')
  	end
  end
end