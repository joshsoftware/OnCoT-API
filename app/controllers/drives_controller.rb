class DrivesController < ApiController
  def drive_time_left
    @drive = Drive.find(params[:id])

    drive_time = @drive.start_time.localtime
    current_time = DateTime.now.localtime

    time_left = drive_time - current_time
    if time_left.negative?
      render json: { message: 'drive already started' }
    else
      render json: { time_left: time_left }
    end
  end
end