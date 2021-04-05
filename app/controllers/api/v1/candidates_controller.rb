# frozen_string_literal: true

module Api
  module V1
    class CandidatesController < ApiController
      before_action :load_drive, only: :candidate_test_time_left
      before_action :load_duration, only: :candidate_test_time_left
      before_action :load_drive_candidate, only: :candidate_test_time_left
      before_action :set_start_time, only: :candidate_test_time_left

      def show
        candidate = Candidate.find(params[:id])
        return unless candidate

        render_success(data: { candidate: serialize_resource(candidate, CandidateSerializer) },
                       message: I18n.t('show.success', model_name: 'Candidate'))
      end

      def update
        candidate = Candidate.find(params[:id])
        if candidate.update(candidate_params)
          render_success(data: { candidate: serialize_resource(candidate, CandidateSerializer) },
                         message: I18n.t('update.success', model_name: 'Candidate'))
        else
          render_error(data: { candidate: serialize_resource(candidate, CandidateSerializer) },
                       message: I18n.t('update.failed', model_name: 'Candidate'))
        end
      end

      def candidate_test_time_left
        @drive_candidate.save if @drive_candidate && @drive_candidate.start_time.nil?

        time_left = (@duration.to_f * 60) - (DateTime.now.localtime - @drive_candidate.start_time.localtime).to_f

        message = if time_left.negative?
                    I18n.t('test.time_over')
                  else
                    I18n.t('test.time_remaining')
                  end
        render_success(data: { time_left: time_left }, message: message)
      end

      private

      def candidate_params
        params.permit(:first_name, :last_name, :email, :is_profile_complete, :created_at, :mobile_number,
                      :updated_at, :created_by_id, :updated_by_id)
      end

      def load_drive
        @drive = Drive.find_by(id: params[:drife_id])
      end

      def load_duration
        @duration = @drive&.duration
      end

      def load_drive_candidate
        @drive_candidate = DrivesCandidate.find_by!(drive_id: params[:drife_id], candidate_id: params[:candidate_id])
      end

      def set_start_time
        @drive_candidate.start_time = DateTime.now.localtime
      end
    end
  end
end
