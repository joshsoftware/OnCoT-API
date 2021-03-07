class CandidatesController < ApiController
  
  def invite
    if params[:emails].blank?
      return render_error(I18n.t("#{:blank_input}.message"), :unprocessable_entity)
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
  end
end
