# frozen_string_literal: true

class DrivesController < ApiController
  def drive_time_left
    drive = Drive.find(params[:id])
    drive_time = drive.start_time.localtime
    current_time = DateTime.now.localtime
    time_left = drive_time - current_time

    if time_left.negative?
      render_success(data: time_left, message: 'Drive is already started', status: 200)
    else
      render_success(data: time_left, message: 'Drive is yet to be started.', status: 200)
    end
  end
end
