class CandidatesController < ApiController
  def invite
    return render_error(I18n.t('blank_input.message'), :unprocessable_entity) if params[:emails].blank?

    emails = params[:emails]
    candidate_emails = emails.split(',')
    failed_invitaion ||= []
    candidate_emails.each do |candidate_email|
      user = Candidate.create(email: candidate_email)
      drive_candidate = DrivesCandidate.create(drive_id: params[:drive_id], candidate_id: user.id)
      next unless user.present? && drive_candidate.present?

      drive_candidate.generate_token!
      begin
        CandidateMailer.with(user: user, drive_candidate: drive_candidate).invitation_email.deliver_now
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

  def update
    token = params[:token].to_s
    if token.blank?
      return render_error(message:I18n.t("#{:token_not_found}.message"), status: :not_found)
    end

    drive_candidate=DrivesCandidate.find_by(token: token)
    candidate =Drive.find_by(id:drive_candidate.candidate_id)
    if candidate.update(candidate_params)
      render_success(data: candidate, message: I18n.t(:message))
    else
      render_error(message: 'Not Updated, Please try again')
    end
  end

  private

  def candidate_params
    params.permit(:first_name, :last_name, :email, :is_profile_complete, :created_at,
                  :updated_at)
  end
end
