# frozen_string_literal: true

require 'csv'
module Api
  module V1
    module Admin
      class DrivesController < ApiController
        before_action :authenticate_user!
        load_and_authorize_resource :drive
        before_action :fetch_drive_data, only: %i[show update candidate_list]
        before_action :data_for_admin_email, only: [:send_admin_email]
        def index
          drives = if params[:page]
                     Drive.paginate(page: params[:page], per_page: 10)
                   else
                     Drive.all
                   end
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
          candidates = @drive.candidates.paginate(page: params[:page], per_page: 10).order('id')
          render_success(data: { candidates: serialize_resource(candidates, CandidateSerializer),
                                 page: candidates.current_page, pages: candidates.total_pages },
                         message: I18n.t('candidate_list.success', model_name: 'Candidate List'))
        end

        def send_admin_email
          if create_csv_file
            AdminMailer.shortlisted_candidates_email(current_user, @drive,
                                                     "driveID_ #{@drive.id}_score_#{@score}.csv").deliver_later
          else
            render_error(message: I18n.t('not_found.message'))
          end
        end

        private

        def fetch_drive_data
          @drive = Drive.find(params[:id])
        end

        def drive_params
          params.permit(:name, :description, :start_time, :end_time, :is_assessment, drives_problems_attributes: %i[id problem_id _destroy])
        end

        def data_for_admin_email
          @drive = Drive.find(params[:drife_id])
          @score = params[:score]
        end

        def create_csv_file
          CSV.open("driveID_ #{@drive.id}_score_#{@score}.csv", 'w') do |csv|
            csv << ['First Name', 'Last Name', 'Email', 'code']
            drives_candidates = DrivesCandidate.where(['drive_id= ? and score >= ?', @drive.id, @score])
            drives_candidates.each do |drives_candidate|
              candidate = drives_candidate.candidate
              submission = drives_candidate.submissions.order('total_marks desc').first
              next unless candidate && submission

              csv << [candidate.first_name, candidate.last_name, candidate.email,
                      submission.answer]
            end
          end
        end
      end
    end
  end
end
