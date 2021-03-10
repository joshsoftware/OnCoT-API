require 'rails_helper'

RSpec.describe CandidatesController, type: :controller do
  context 'candidates#update' do
    let(:organization) { create(:organization) }
    let(:user) { create(:user) }
    let(:candidate) { create(:candidate) }
    let(:drive) do
      create(:drive, updated_by_id: user.id, created_by_id: user.id,
                     organization: organization)
                  
    end
   
    let(:drives_candidate) { create(:drives_candidate, drive_id: drive.id, candidate_id: candidate.id) }

    it 'update the candidate details' do
      byebug
      patch :update,  params: { id: drives_candidate.candidate_id}

      expect(response.body).to eq({ data: candidate, message: 'Success' }.to_json)
      expect(response).to have_http_status(200)
    end
  end
end

