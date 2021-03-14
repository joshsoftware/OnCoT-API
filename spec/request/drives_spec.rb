# frozen_string_literal: true

require 'rails_helper'
require 'time'

RSpec.describe DrivesController, type: :controller do
  describe 'drive is yet to start' do
    it 'returns true if start time < current time' do
      p '------------hey------------'
      drive = create(:drive)
      p drive, '---------hey2-------------'
      travel_to(Time.current - 1.day)
      expect(drive.yet_to_start?).to eq(true)
    end

    it 'return true if end time > current time' do
      drive = create(:drive)
      travel_to(Time.current - 1.day)
      expect(drive.ended?).to eq(false)
    end
  end

  describe 'drive is completed' do
    it 'return false if start time < current time' do
      drive = create(:drive)
      travel 4.day
      expect(drive.yet_to_start?).to eq(false)
    end

    it 'return true if end time < current time' do
      drive = create(:drive)
      travel 4.day
      expect(drive.ended?).to eq(true)
    end
  end

  describe 'ongoing drive' do
    it 'return true if start time < current time < end time' do
      drive = create(:drive)
      travel 1.day
      expect(drive.ongoing?).to eq(true)
    end
  end
end
