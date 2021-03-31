# frozen_string_literal: true

class DriveEndsController < ApiController
  def show
    candidate_id = params[:id]
    if (drives_candidate = DrivesCandidate.find_by(candidate_id: candidate_id))
      drives_candidate.update(completed_at: Time.now)
      render_success(message: I18n.t('success.message'))
    else
      render_error(message: I18n.t('not_found.message'))
    end
  end
end
