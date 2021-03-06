# frozen_string_literal: true

module Api
  module V1
    module Admin
      class AssessmentsController < ApiController
        before_action :authenticate_token
        before_action :fetch_drive_data, only: %i[create]

        def index
          drives = Drive.where(is_assessment: true)
          render json: { assessments: serialize_resource(drives, AssessmentSerializer) }
        end

        def create # rubocop:disable Metrics/AbcSize
          candidate = Candidate.find_or_initialize_by(email: params[:email])
          candidate.save
          drive_candidate = DrivesCandidate.new(candidate_id: candidate.id, drive_id: @drive.id, application_id: params[:application_id],
                                                drive_start_time: params[:start_time] || Time.current,
                                                drive_end_time: params[:end_time] || Time.current + 1.year)
          drive_candidate.generate_token
          drive_candidate_save(candidate, drive_candidate)
        end

        def drive_candidate_save(candidate, drive_candidate)
          if drive_candidate.save
            CandidateMailer.invitation_email(candidate, drive_candidate).deliver_later
            render_success(data: { assessment_schedule_id: drive_candidate.uuid }, message: I18n.t('ok.message'))
          else
            render_error(message: drive_candidate.errors.full_messages)
          end
        end

        private

        def fetch_drive_data
          @drive = Drive.where(uuid: params[:assessment_id]).first
          render_error(message: I18n.t('not_found.message')) unless @drive
        end

        def drive_params
          params.permit(:name, :description, :start_time, :end_time, drives_problems_attributes: %i[id problem_id _destroy])
        end

        # TODO: - Organization should be loaded from drive
        def authenticate_token
          return unless request.headers['HTTP_AUTHORIZATION'] != Organization.first.auth_token

          render_error(message: I18n.t('auth_token.invalid'))
        end
      end
    end
  end
end
