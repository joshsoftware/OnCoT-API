# frozen_string_literal: true

class CandidatesController < ApiController
  before_action :fetch_drive, only: %i[show edit update]
  before_action :fetch_duration, only: %i[show edit update]
  before_action :fetch_drive_candidate, only: %i[show edit update]

  def fetch_drive
    @drive = Drive.find_by_id(params[:drife_id])
  end

  def fetch_duration
    @duration = @drive.duration if @drive
  end

  def fetch_drive_candidate
    @drive_candidate = DrivesCandidate.find_by!(drive_id: params[:drife_id], candidate_id: params[:candidate_id])
  end

  def candidate_time_left
    if @drive_candidate && @drive_candidate.start_time.nil?
      @drive_candidate.start_time = DateTime.now.utc
      @drive_candidate.save
    end

    time_left = duration * 60 - (DateTime.now.utc - @drive_candidate.start_time).to_f

    if time_left.negative?
      render_success(message: 'Test Time Over!', status: 200)
    else
      render_success(data: time_left, message: 'Time Remaining', status: 200)
    end
  end

  def update
    candidate = Candidate.find_by(id: params[:id])
    if candidate.update(candidate_params)
      render_success(data: candidate, message: I18n.t('update.success', model_name: 'Candidate'))
    else
      render_error(message: 'Not Updated, Please try again', status: 400)
    end
  end

  private

  def candidate_params
    params.permit(:first_name, :last_name, :email, :is_profile_complete, :drive_id, :invite_status, :created_at,
                  :updated_at)
  end
end
