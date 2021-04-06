# frozen_string_literal: true

class CandidateMailer < ApplicationMailer
  def invitation_email(user, drive_candidate)
    @token = drive_candidate.token.to_s
    @drive = drive_candidate.drive

    mail(to: user.email, from: ENV['MAIL_USERNAME'], subject: "Invitation for #{@drive.organization.name}
      #{@drive.name} coding round by OnCot",
         message: 'Link has been sent')
  end
end
