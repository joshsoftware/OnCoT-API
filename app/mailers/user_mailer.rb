# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def user_invitation_email(email, role, current_user, invitation_token)
    @current_user = current_user
    @role = Role.find(role)
    @email = email
    @invitation_token = invitation_token

    mail(to: email, from: Figaro.env.MAIL_USERNAME, subject: "Invitation to join #{@current_user.organization.name} on OnCot as #{@role.name}",
         message: 'Link has been sent')
  end
end
