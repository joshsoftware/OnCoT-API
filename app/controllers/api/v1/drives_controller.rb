# frozen_string_literal: true

module Api
  module V1
    class DrivesController < ApiController
      before_action :load_drive

      def show
        render_success(data: { drive: @drive, drive_start_time: @drive_candidate.drive_start_time,
                               drive_end_time: @drive_candidate.drive_end_time, candidate_id: @drive_candidate.candidate_id }, message: I18n.t('ok.message'),
                       status: 200)
      end

      def drive_time_left
        time_left_to_end = @drive_candidate.drive_end_time - DateTime.current
        time_left_to_start = @drive_candidate.drive_start_time - DateTime.current

        if time_left_to_end.negative? || test_already_taken?
          data = -1
          is_live = false
          message = I18n.t('drive.ended')
        else
          is_live = true
          if time_left_to_start.negative?
            data = -1
            message = I18n.t('drive.started')
          else
            data = time_left_to_start
            message = I18n.t('drive.yet_to_start')
          end
        end

        render_success(data: { data: data, is_live: is_live }, message: message)
      end

      private

      def load_drive
        @drive_candidate = DrivesCandidate.find_by(token: params[:id])
        if @drive_candidate
          @drive = Drive.find(@drive_candidate.drive_id)
        else
          render_error(message: I18n.t('drive_not_found.message'), status: :not_found)
        end
      end

      def test_already_taken?
        @drive_candidate.end_time && @drive_candidate.end_time < DateTime.current
      end
    end
  end
end
