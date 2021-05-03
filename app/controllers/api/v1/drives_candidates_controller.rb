# frozen_string_literal: true

module Api
  module V1
    class DrivesCandidatesController < ApiController
      before_action :find_submission
      def update
        if (drives_candidate = DrivesCandidate.find_by(candidate_id: params[:id], drive_id: params[:drive_id]))
          if drives_candidate.update(completed_at: DateTime.now)
            render_success(data: drives_candidate.completed_at.iso8601, message: I18n.t('success.message'))
          else
            render_error(message: I18n.t('error.message'))
          end
        else
          render_error(message: I18n.t('not_found.message'))
        end
      end

      def show_code
        if @submission
          render_success(data: { answer: @submission.answer }, message: I18n.t('success.message'))
        else
          render_error(message: I18n.t('not_found.message'))
        end
      end

      private

      def find_submission
        @drive_candidate = DrivesCandidate.find(params[:drives_candidate_id])
        @submission = Submission.find_by(drives_candidate_id: @drive_candidate.id)
      end
    end
  end
end
