# frozen_string_literal: true

class AdminMailer < ApplicationMailer
  def shortlisted_candidates_email(user, drive, candidates_list)
    attachments['candidates_list.csv'] = { mime_type: 'text/csv', content: File.read(Rails.root.join(candidates_list)) }
    mail(to: user.email, from: Figaro.env.MAIL_USERNAME, subject: "Shorlisted Candidates' list for
         #{drive.name} ", message: 'candidate list sent')
  end
end
