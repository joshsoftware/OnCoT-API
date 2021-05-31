# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def user_invitation_email(email, role, current_user)
    @organization = current_user.organization
    @current_user = current_user
    @role = Role.find(1)

    mail(to: email, from: Figaro.env.MAIL_USERNAME, subject: "Invitation to join #{@organization.name} on OnCot as #{@role.name}",
         message: 'Link has been sent')
  end
end
