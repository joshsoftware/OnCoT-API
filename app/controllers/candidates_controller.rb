class CandidatesController < ApiController
  def invite
    if params[:emails].blank?
      return render_error(message:I18n.t("#{:blank_input}.message"), status: :unprocessable_entity)
    end

    emails=params[:emails]
    candidate_emails=emails.split(',')
    failed_invitaion ||= []
    candidate_emails.each do |candidate_email|
      user=Candidate.create(email:candidate_email)
      drive_candidate=DrivesCandidate.create(drive_id: params[:drive_id],candidate_id: user.id)
      if user.present? && drive_candidate.present?
        drive_candidate.generate_token!
        begin
          CandidateMailer.with(user: user, drive_candidate: drive_candidate ).invitation_email.deliver_now
        rescue => e
          failed_invitaion.push(candidate_email)
        end
      end
    end

    if failed_invitaion.empty? 
      return render_success(message: I18n.t("#{:ok}.message"))
    else
      render json: {failed_invitaion:failed_invitaion}
    end
    
  def update
    candidate = Candidate.find_by_id(params[:id])
    if candidate.update(candidate_params)
      render_success(data: candidate, message: I18n.t(:message))
    else
      render_error(message: 'Not Updated, Please try again')
    end
  end

  private

  def candidate_params
    params.permit(:first_name, :last_name, :email, :is_profile_complete, :drive_id, :invite_status, :created_at,
                  :updated_at)
  end
end
