FactoryBot.define do
  factory :user, class: User do
    email { Faker::Internet.email }
    password { 'password' }

    before(:create) do |user|
      user.organization = FactoryBot.create(:organization)
      user.role = FactoryBot.create(:role)
    end
  end
end
