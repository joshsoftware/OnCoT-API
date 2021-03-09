class DrivesController < ApiController
  def show
    token = params[:token].to_s
    return render_error(message: I18n.t('token_not_found.message'), status: :not_found) if token.blank?

    drive_candidate = DrivesCandidate.find_by(token: token)
    drive = Drive.find_by(id: drive_candidate.drive_id)
    if drive.present? && drive_candidate.token_valid?
      render_success(data: drive, message: I18n.t('ok.message'))
    else
      render_error(message: I18n.t('drive_not_found.message'), stats: :not_found)
    end
  end
end
