require 'rails_helper'

RSpec.describe CandidatesController, type: :controller do
  before do
    @organization = create(:organization)
    @user =  create(:user)
    @drive = create(:drive, updated_by_id: @user.id, created_by_id: @user.id,
                            organization: @organization)
  end

  it 'Updates the candidate  details' do
    @candidate = create(:candidate, drive_id: @drive.id)
    get :update, params: { id: @candidate.id }
    
    expect(response).to have_http_status(200)
  end
end
