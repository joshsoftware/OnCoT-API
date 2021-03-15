# frozen_string_literal: true

class CandidatesController < ApiController
  def show
    candidate = Candidate.find_by(id: params[:id])
    render_success(data: candidate, message: I18n.t('show.success', model_name: 'Candidate'))
  end

  def update
    candidate = Candidate.find_by(id: params[:id])
    if candidate.update(candidate_params)
      render_success(data: candidate, message: I18n.t('update.success', model_name: 'Candidate'))
    else
      render_error(message: 'Not Updated, Please try again', status: 400)
    end
  end
  # before_action :fetch_drive, only: %i[show edit update]
  # before_action :fetch_duration, only: %i[show edit update]
  # before_action :fetch_drive_candidate, only: %i[show edit update]

  def fetch_drive
    @drive = Drive.find_by_id(params[:drife_id])
  end

  def fetch_duration
    @duration = @drive.duration if @drive
  end

  def fetch_drive_candidate
    @drive_candidate = DrivesCandidate.find_by!(drive_id: params[:drife_id], candidate_id: params[:candidate_id])
  end

  def set_start_time
    @drive_candidate.start_time = DateTime.now.utc
  end

  def candidate_test_time_left
    fetch_drive
    fetch_duration
    fetch_drive_candidate
    set_start_time

    if @drive_candidate && @drive_candidate.start_time.nil?
      set_start_time
      @drive_candidate.save
    end

    time_left = (@duration.to_f * 60) - (DateTime.now.utc - @drive_candidate.start_time).to_f
    data = {
      time_left: time_left,
      start_time: @drive_candidate.start_time,
      duration: @duration
    }
    if time_left.negative?
      render_success(data: data, message: 'Test Time Over!', status: 200)
    else
      render_success(data: data, message: 'Time Remaining', status: 200)
    end
  end

  private

  def candidate_params
    params.permit(:first_name, :last_name, :email, :is_profile_complete, :drive_id, :invite_status, :created_at,
                  :updated_at)
  end
end
