class CandidatesController < ApplicationController
  def candidate_test_time_left
    drive = Drive.find_by_id(params[:drife_id])
    duration = drive.duration if drive

    drive_candidate = DrivesCandidate.find_by!(drive_id: params[:drife_id], candidate_id: params[:candidate_id])
    if drive_candidate and drive_candidate.start_time.nil?
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
end
