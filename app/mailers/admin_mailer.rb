# frozen_string_literal: true

class AdminMailer < ApplicationMailer
  def shortlisted_candidates_email(user, drive, candidates, submissions)
    @drive = drive
    @candidates = candidates
    @submissions = submissions
    mail(to: user.email, from: Figaro.env.MAIL_USERNAME, subject: "shorlisted candidates list for
      #{drive.name} ", message: 'candidate list sent')
  end
end
