# frozen_string_literal: true

module Api
  module V1
    class DrivesController < ApiController
      before_action :load_drive

      def show
        return render_error(message: I18n.t('drive_not_found.message'), status: :not_found) if @drive_candidate.blank?

        if @drive.present?
          render_success(data: { drive: @drive, candidate_id: @drive_candidate.candidate_id }, message: I18n.t('ok.message'),
                         status: 200)
        else
          render_error(message: I18n.t('drive_not_found.message'), status: :not_found)
        end
      end

      def drive_time_left
        set_time_left_to_start
        set_time_left_to_end

        if @time_left_to_end.positive?
          is_live = true
          if @time_left_to_start.negative?
            data = test_already_taken? ? -1 : 0
            message = I18n.t('drive.started')
          else
            data = @time_left_to_start
            message = I18n.t('drive.yet_to_start')
          end
        else
          data = -1
          is_live = false
          message = I18n.t('drive.ended')
        end

        render_success(data: {data: data, is_live: is_live}, message: message)
      end

      private

      def load_drive
        @drive_candidate = DrivesCandidate.find_by(token: params[:id])
        @drive = Drive.find_by(id: @drive_candidate.drive_id)
      end

      def test_already_taken?
        @drive_candidate.end_time && @drive_candidate.end_time < DateTime.current
      end

      def set_time_left_to_start
        @time_left_to_start = @drive.start_time - DateTime.current
      end

      def set_time_left_to_end
        @time_left_to_end = @drive.end_time - DateTime.current
      end
    end
  end
end
