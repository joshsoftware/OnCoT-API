# frozen_string_literal: true

module Api
  module V1
    class DrivesController < ApiController
      before_action :load_drive, only: :drive_time_left
      before_action :set_time_data, only: :drive_time_left

      def show
        drive_candidate = DrivesCandidate.find_by(token: params[:id])
        return render_error(message: I18n.t('drive_not_found.message'), status: :not_found) if drive_candidate.blank?

        drive = Drive.find_by(id: drive_candidate.drive_id)
        if drive.present?
          render json: { data: drive, candidate_id: drive_candidate.candidate_id, message: I18n.t('ok.message') }, status: 200
        else
          render_error(message: I18n.t('drive_not_found.message'), status: :not_found)
        end
      end

      def drive_time_left
        if @time_left_to_start.negative?
          message = @time_left_already_stated.positive? ? I18n.t('drive.started') : I18n.t('drive.ended')

          data = @time_left_already_stated
        else
          data = @time_left_to_start
          data -= 330.minutes
          message = I18n.t('drive.yet_to_start')
        end
        render_success(data: data, message: message)
      end

      private

      def load_drive
        @drive = Drive.find(params[:id])
      end

      def set_time_data
        drive_start_time = @drive.start_time.in_time_zone(TZInfo::Timezone.get('Asia/Kolkata'))
        drive_end_time = @drive.end_time.in_time_zone(TZInfo::Timezone.get('Asia/Kolkata'))
        current_time = DateTime.now.in_time_zone(TZInfo::Timezone.get('Asia/Kolkata'))
        @time_left_to_start = drive_start_time - current_time
        @time_left_already_stated = drive_end_time - current_time
      end
    end
  end
end
