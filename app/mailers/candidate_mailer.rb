class CandidateMailer < ApplicationMailer

  def invitation_email
    @user = params[:user]
    @drive_candidate=params[:drive_candidate]
    mail(to: @user.email , from: 'MAIL_USERNAME', subject: 'Invitation for coding round', message:'Link has been sent')
  end
end