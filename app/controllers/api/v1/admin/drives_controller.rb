# frozen_string_literal: true

module Api
  module V1
    module Admin
      class DrivesController < ApiController
        before_action :authenticate_user!
        load_and_authorize_resource :drive
        before_action :fetch_drive_data, only: %i[show update]
        before_action :fetch_problem_data, only: %i[update create]
        before_action :fetch_drives_problem_data, only: %i[update]
        before_action :merge_drive_params, only: %i[update create]

        def index
          drives = Drive.all
          render_success(data: { drives: serialize_resource(drives, DriveSerializer) },
                         message: I18n.t('index.success', model_name: 'Drive'))
        end

        def create
          drive = Drive.new(@drive_params)
          if drive.save
            DrivesProblem.create(drive_id: drive.id, problem_id: @problem.id)
            render_success(data: { drive: serialize_resource(drive, DriveSerializer) },
                           message: I18n.t('create.success', model_name: 'Drive'))
          else
            render_error(message: drive.errors.messages, status: 400)
          end
        end

        def update
          if @drive.update(@drive_params)
            @drives_problem.update(problem_id: @problem.id)
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

        private

        def fetch_drive_data
          @drive = Drive.find(params[:id])
        end

        def fetch_problem_data
          @problem = Problem.find(params[:problem_id])
        end

        def fetch_drives_problem_data
          @drives_problem = DrivesProblem.find_by(drive_id: @drive.id)
          render_error(message: I18n.t('not_found.message'), status: 404) unless @drives_problem
        end

        def merge_drive_params
          @drive_params = drive_params.merge(created_by_id: current_user.id, updated_by_id: current_user.id,
                                             organization_id: current_user.organization_id)
        end

        def drive_params
          params.permit(:name, :description, :start_time, :end_time)
        end
      end
    end
  end
end
