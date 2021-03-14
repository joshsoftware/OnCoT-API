# frozen_string_literal: true

class DrivesController < ApiController
  def drive_time_left
    @drive = Drive.find(params[:id])

    drive_time = @drive.start_time.localtime
    current_time = DateTime.now.localtime
    time_left = drive_time - current_time

    if time_left.negative?
      render_success(message: 'Drive has been started already.', status: 200)
    else
      render json: { time_left: time_left }
    end
  end
end
