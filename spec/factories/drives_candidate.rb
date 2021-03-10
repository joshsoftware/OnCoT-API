FactoryBot.define do
    factory :drives_candidate, class: DrivesCandidate do
        before(:create) do |drives_candidate|
            drives_candidate.candidate = create(:candidate)
            drives_candidate.drive = create(:drive, create(:user, create(:organization ), create(:role)))
        end
      created_at { Time.now }
      updated_at { Time.now }


    end
end
   