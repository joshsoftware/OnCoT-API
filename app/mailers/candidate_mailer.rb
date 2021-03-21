# frozen_string_literal: true

class CandidateMailer < ApplicationMailer
  def invitation_email(user, drive_candidate)
    @token = drive_candidate.token.to_s
    mail(to: user.email, from: ENV['MAIL_USERNAME'], subject: 'Invitation for coding round',
         message: 'Link has been sent')
  end
end
