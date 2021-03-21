# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CandidatesController, type: :controller do
  let(:user) { double Candidate, first_name: 'abc', email: 'abc@gmail.com' }
  let(:drive_candidate) { double DrivesCandidate, token: 'abcdefgjijklmnop' }

  it 'sends an email' do
    expect { CandidateMailer.invitation_email(user, drive_candidate).deliver_now }.to change {
                                                                                        ActionMailer::Base.deliveries.count
                                                                                      }.by(1)
  end
end
