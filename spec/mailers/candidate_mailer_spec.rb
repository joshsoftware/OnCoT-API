# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CandidateMailer, type: :mailer do
  describe 'invitation_email' do
    let(:user) { double Candidate, first_name: 'abc', email: 'abc@gmail.com' }
    let(:drive_candidate) { double DrivesCandidate, token: 'abcdefgjijklmnop' }
    let(:mail) { described_class.invitation_email(user, drive_candidate).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq('Invitation for coding round')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq([ENV['MAIL_USERNAME']])
    end

    it 'assigns @confirmation_url' do
      expect(mail.body.encoded)
        .to match("http://localhost:3000/overview/#{drive_candidate.token}")
    end
  end
end
