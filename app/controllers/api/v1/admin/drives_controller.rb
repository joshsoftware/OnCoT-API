# frozen_string_literal: true

module Api
  module V1
    module Admin
      class DrivesController < ApiController
        before_action :authenticate_user!
        load_and_authorize_resource :drive
        before_action :fetch_drive_data, only: %i[show update candidate_list]

        def index
          drives = Drive.all
          render_success(data: { drives: serialize_resource(drives, DriveSerializer) },
                         message: I18n.t('index.success', model_name: 'Drive'))
        end

        def create
          @drive = Drive.create!(drive_params.merge(created_by_id: current_user.id, updated_by_id: current_user.id,
                                                    organization_id: current_user.organization_id))

          if @drive
            render_success(data: { drive: serialize_resource(@drive, DriveSerializer) },
                           message: I18n.t('create.success', model_name: 'Drive'))
          else
            render_error(message: @drive.errors.messages, status: 400)
          end
        end

        def update
          if @drive.update!(drive_params.merge(updated_by_id: current_user.id,
                                               organization_id: current_user.organization_id))
            render_success(data: { drive: serialize_resource(@drive, DriveSerializer) },
                           message: I18n.t('update.success', model_name: 'Drive'))
          else
            render_error(message: I18n.t(@drive.errors.messages, model_name: 'Drive'), status: 400)
          end
        end

        def show
          render_success(data: { drive: serialize_resource(@drive, DriveSerializer) },
                         message: I18n.t('show.success', model_name: 'Drive'))
        end

        def candidate_list
          render_success(data: { candidates: serialize_resource(@drive.candidates, CandidateSerializer) },
                         message: I18n.t('candidate_list.success', model_name: 'Candidate List'))
        end

        def send_admin_email
          drive = Drive.find(params[:drife_id])
          drives_candidates = DrivesCandidate.where(drive_id: drive.id)
          score = params[:score]
          user = current_user
          candidates = []
          submissions = []
          drives_candidates.each do |drives_candidate|
            if drives_candidate.score && drives_candidate.score >= score.to_i
              candidate = Candidate.find_by(id: drives_candidate.candidate_id)
              submission = Submission.find_by(drives_candidate_id: drives_candidate.id)
              next unless candidate && submission

              candidates << candidate
              submissions << submission
            end
          end
          AdminMailer.shortlisted_candidates_email(user, drive, candidates, submissions).deliver_later
        end

        private

        def fetch_drive_data
          @drive = Drive.find(params[:id])
        end

        def drive_params
          params.permit(:name, :description, :start_time, :end_time, drives_problems_attributes: %i[id problem_id _destroy])
        end
      end
    end
  end
end
