# frozen_string_literal: true

class CandidatesController < ApiController
  before_action :load_drive, only: :candidate_test_time_left
  before_action :load_duration, only: :candidate_test_time_left
  before_action :load_drive_candidate, only: :candidate_test_time_left
  before_action :set_start_time, only: :candidate_test_time_left

  def show
    candidate = Candidate.find(params[:id])
    return unless candidate

    render_success(data: candidate, message: I18n.t('show.success', model_name: 'Candidate'))
  end

  def update
    candidate = Candidate.find(params[:id])
    return unless candidate.update(candidate_params)

    render_success(data: candidate, message: I18n.t('update.success', model_name: 'Candidate'))
  end

  def candidate_test_time_left
    @drive_candidate.save if @drive_candidate && @drive_candidate.start_time.nil?

    time_left = (@duration.to_f * 60) - (DateTime.now.localtime - @drive_candidate.start_time.localtime).to_f

    if time_left.negative?
      render_success(data: { time_left: time_left }, message: I18n.t('test.time_over'), status: 200)
    else
      render_success(data: { time_left: time_left }, message: I18n.t('test.time_remaining'), status: 200)
    end
  end

  private

  def candidate_params
    params.permit(:first_name, :last_name, :email, :is_profile_complete, :created_at, :mobile_number,
                  :updated_at, :created_by_id, :updated_by_id)
  end

  def load_drive
    # byebug
    @drive = Drive.find_by(id: params[:drife_id])
  end

  def load_duration
    @duration = @drive.duration if @drive
  end

  def load_drive_candidate
    @drive_candidate = DrivesCandidate.find_by!(drive_id: params[:drife_id], candidate_id: params[:candidate_id])
  end

  def set_start_time
    @drive_candidate.start_time = DateTime.now.localtime
  end
end
