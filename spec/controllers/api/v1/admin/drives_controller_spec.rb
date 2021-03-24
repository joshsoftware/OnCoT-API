# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DrivesController, type: :controller do
  before do
    @organization = create(:organization)
    @user = create(:user)
  end

  describe 'GET drive_time_left', type: :request do
    context 'check http response' do
      it 'check /drive/:id response' do
        drive = create(:drive, updated_by_id: @user.id, created_by_id: @user.id,
                               organization: @organization)
        get "/drives/#{drive.id}/drive_time_left", params: { id: drive.id }
        expect(response).to have_http_status(200)
      end
    end

    context 'drive is yet to start' do
      it 'returns true if start time > current time' do
        drive = create(:drive, updated_by_id: @user.id, created_by_id: @user.id,
                               organization: @organization)
        travel_to(DateTime.current.localtime - 1.hours)
        expect(drive.yet_to_start?).to eq(true)
      end

      it 'return true if end time > current time' do
        drive = create(:drive, updated_by_id: @user.id, created_by_id: @user.id,
                               organization: @organization)
        travel_to(DateTime.current.localtime - 1.hours)
        expect(drive.ended?).to eq(false)
      end
    end

    context 'drive is completed' do
      it 'return false if start time > current time' do
        drive = create(:drive, updated_by_id: @user.id, created_by_id: @user.id,
                               organization: @organization)
        travel 4.hours
        expect(drive.yet_to_start?).to eq(false)
      end

      it 'return true if end time < current time' do
        drive = create(:drive, updated_by_id: @user.id, created_by_id: @user.id,
                               organization: @organization)
        travel 4.hours
        expect(drive.ended?).to eq(true)
      end
    end

    context 'ongoing drive' do
      it 'return true if start time < current time < end time' do
        drive = create(:drive, updated_by_id: @user.id, created_by_id: @user.id,
                               organization: @organization)
        travel 1.hours
        expect(drive.ongoing?).to eq(true)
      end
    end
  end
end
