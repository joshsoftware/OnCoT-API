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

      def appeared_for_test
        if (@drives_candidate = DrivesCandidate.find_by(id: params[:drives_candidate_id]))
          if @drives_candidate.completed_at
            render_error(message: I18n.t('error.message'))
          else
            render_success(message: I18n.t('success.message'))
          end
        else
          render_error(message: I18n.t('not_found.message')) unless @drives_candidate
        end
      end
    end
  end
end
