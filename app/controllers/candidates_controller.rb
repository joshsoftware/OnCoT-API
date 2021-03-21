# frozen_string_literal: true

class CandidatesController < ApiController
  def invite
    return render_error(I18n.t('blank_input.message'), :unprocessable_entity) if params[:emails].blank?

    emails = params[:emails]
    candidate_emails = emails.split(',')
    failed_invitaion ||= []
    candidate_emails.each do |candidate_email|
      user = Candidate.new(email: candidate_email)
      drive_candidate = DrivesCandidate.new(drive_id: params[:drive_id], candidate_id: user.id) if user.save

      next unless user.present? && drive_candidate.save

      drive_candidate.generate_token!
      begin
        CandidateMailer.invitation_email(user, drive_candidate).deliver_later
      rescue StandardError => e
        failed_invitaion.push(candidate_email)
      end
    end

    if failed_invitaion.empty?
      render_success(message: I18n.t('ok.message'))
    else
      render json: { failed_invitaion: failed_invitaion }
    end
  end
end
