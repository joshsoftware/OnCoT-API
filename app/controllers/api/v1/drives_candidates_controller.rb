# frozen_string_literal: true

module Api
  module V1
    class DrivesCandidatesController < ApiController
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
        @drive_candidate = DrivesCandidate.find(params[:drives_candidate_id])
        @submission = @drive_candidate.submissions.order('total_marks desc').first
        if @submission
          render_success(data: { answer: @submission.answer, total_marks: @submission.total_marks },
                         message: I18n.t('success.message'))
        else
          render_error(message: I18n.t('not_found.message'))
        end
      end
    end
  end
end
