require 'rails_helper'

RSpec.describe DrivesController, type: :controller do
  before do
    @organization = FactoryBot.create(:organization)
    @user = FactoryBot.create(:user)
  end

  describe 'time api test', type: :request do
    context 'check http response' do
      it 'check /drive/:id response' do
        @drive = FactoryBot.create(:drive, updated_by_id: @user.id, created_by_id: @user.id,
                                           organization: @organization)

        get "/drives/#{@drive.id}/drive_time_left", params: { id: @drive.id }
        expect(response).to have_http_status(200)
      end
    end
  end
end
