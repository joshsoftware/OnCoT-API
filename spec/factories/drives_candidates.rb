FactoryBot.define do
    factory :drives_candidates, class: DrivesCandidates do
        # candidate = create{:candidate}
     created_at {Time.now}
     updated_at {Time.now}

     before(:create) do |drives_candidates|
        drives_candidates.candidate = create(:candidate)
     end
  end
end