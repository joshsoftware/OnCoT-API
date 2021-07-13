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

      def assessment_status
        drive_candidate = DrivesCandidate.find_by(token: params[:token])
        render_error(message: I18n.t('not_found.message')) unless drive_candidate
        if drive_candidate.drive.is_assessment? 
          params = {key: 'yKkwJQFnFQL6qaVS4fZkdmt3FJRjvsyk', assessment_schedule_id: drive_candidate.uuid, score: drive_candidate.score }
          if drive_candidate.drive_end_time < DateTime.current
            render_success( data: params.merge(status: 'expired'), message: I18n.t('drive.ended'))
          end
          time = drive_candidate.end_time - drive_candidate.start_time
          body = AssessmentReportJob.perform_later(params)
          if body
            render_success( data: {}, message: I18n.t('success.message') )
          else
            render_error(message: I18n.t('not_found.message'), status: 404)
          end
        end
      end
    end
  end
end
