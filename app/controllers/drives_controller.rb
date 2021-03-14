class DrivesController < ApiController
  def drive_time_left
    drive = Drive.find(params[:id])
    if DateTime.now.utc > drive.end_time
      render_error(message: 'drive ended')
      return
    end
    
    drive_time = drive.start_time.localtime
    current_time = DateTime.now.localtime

    time_left = drive_time - current_time
    if time_left.negative?
      render_error(message: 'drive already started')
    else
      render_success(data: time_left, message: 'timeleft')
    end
  end

  # def candidate_test_time_left
  #   drive = Drive.find(params[:drife_id])
  #   duration = drive.duration if drive

  #   drive_candidate = DrivesCandidate.find_by!(drive_id: params[:drife_id], candidate_id: params[:candidate_id])
  #   if drive_candidate.start_time.nil?
  #     drive_candidate.start_time = DateTime.now.utc
  #     drive_candidate.save
  #   end
  #   time_left = duration * 60 - (DateTime.now.utc - drive_candidate.start_time).to_f
  #   if time_left.negative?
  #     render json: { message: 'time over' }
  #   else
  #     render json: { time_left: time_left }
  #   end
  # end

end
  