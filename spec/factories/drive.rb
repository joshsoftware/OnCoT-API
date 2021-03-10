FactoryBot.define do
  factory :drive, class: Drive do
    name { 'drive1' }
    description { 'Drive details' }
    created_at { Time.now }
    updated_at { Time.now }

    # before(:create) do |drive|
    #   drive.organization = create(:organization)
    #   drive.user = create(:user)
    # end
  end
end
