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
        time_left_to_end = @drive.end_time - DateTime.current

        if time_left_to_end.negative? || test_already_taken?
          data = -1
          is_live = false
          message = I18n.t('drive.ended')
        else
          is_live = true
          data = @drive.start_time - DateTime.current
          message = I18n.t('drive.yet_to_start')
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
    end
  end
end
