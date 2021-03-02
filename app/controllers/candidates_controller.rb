class CandidatesController < ApiController
  def update
    candidate = Candidate.find(params[:id])
    if candidate.update(candidate_params)
      render_succeess(message: 'successfully added details', data: candidate)
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
