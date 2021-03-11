# frozen_string_literal: true

class CandidatesController < ApiController
  before_action :find_candidate

  def update
    if (candidate = @drive_candidate.candidate)
      if candidate.update(candidate_params)
        render_success(data: candidate, message: I18n.t('success.message'))
      else
        render_error(message: I18n.t('error.message'))
      end
    else
      render_error(message: I18n.t('not_found.message'))
    end
  end

  private

  def candidate_params
    params.permit(:first_name, :last_name, :email, :is_profile_complete, :created_at, :mobile_number,
                  :updated_at, :drive_id, :created_by_id, :updated_by_id)
  end

  def find_candidate
    token = params[:id].to_s
    @drive_candidate = DrivesCandidate.find_by(token: token)
    return render_error(message: I18n.t('token_not_found.message'), status: :not_found) if @drive_candidate.blank?
  end
end
