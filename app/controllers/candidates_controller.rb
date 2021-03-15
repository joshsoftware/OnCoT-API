# frozen_string_literal: true

class CandidatesController < ApiController
  def update
    candidate = Candidate.find_by_id(params[:id])
    if candidate.update(candidate_params)
      render_success(data: candidate, message: I18n.t(:message))
    else
      render_error(message: 'Not Updated, Please try again')
    end
  end

  def candidate_test_time_left
    drive = Drive.find_by_id(params[:drife_id])
    duration = drive.duration if drive

    drive_candidate = DrivesCandidate.find_by!(drive_id: params[:drife_id], candidate_id: params[:candidate_id])
    if drive_candidate && drive_candidate.start_time.nil?
      drive_candidate.start_time = DateTime.now.utc
      drive_candidate.save
    end
    time_left = duration * 60 - (DateTime.now.utc - drive_candidate.start_time).to_f
    if time_left.negative?
      render json: { message: 'time over' }
    else
      render json: { time_left: time_left }
    end
  end

  private

  def candidate_params
    params.permit(:first_name, :last_name, :email, :is_profile_complete, :drive_id, :invite_status, :created_at,
                  :updated_at)
  end
end
