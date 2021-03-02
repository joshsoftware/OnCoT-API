require 'rails_helper'

RSpec.describe CandidatesController, type: :controller do
  before do
    @organization = FactoryBot.create(:organization)
    @user = FactoryBot.create(:user)
    @drive = FactoryBot.create(:drive, updated_by_id: @user.id, created_by_id: @user.id,
                                       organization: @organization)
  end

  it 'Updates the candidate  details' do
    @candidate = FactoryBot.create(:candidate, drive_id: @drive.id)
    get :update, params: { id: @candidate.id }
    expect(JSON.parse(response.body).size).to eq(2)
    expect(response).to have_http_status(200)
  end
end
