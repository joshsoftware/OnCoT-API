# frozen_string_literal: true

class DrivesController < ApiController
  before_action :load_drive
  before_action :set_time_data

  def drive_time_left
    if @time_left_to_start.negative?
      if @time_left_already_stated.positive?
        render_success(data: @time_left_already_stated, message: I18n.t('drive.started'))
      else
        render_success(data: @time_left_already_stated, message: I18n.t('drive.ended'))
      end
    else
      render_success(data: @time_left_to_start, message: I18n.t('drive.yet_to_start'), status: 200)
    end
  end

  private

  def load_drive
    @drive = Drive.find(params[:id])
  end

  def set_time_data
    @drive_start_time = @drive.start_time.localtime
    @drive_end_time = @drive.end_time.localtime
    @current_time = DateTime.now.localtime
    @time_left_to_start = @drive_start_time - @current_time
    @time_left_already_stated = @drive_end_time - @current_time
  end
end
