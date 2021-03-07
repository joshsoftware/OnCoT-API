FactoryBot.define do
  factory :user, class: User do
    association :organization
    email { Faker::Internet.email }
    password { 'password' }

    before(:create) do |user|
      user.organization = create(:organization)
      user.role = create(:role)
    end
  end
end
