# frozen_string_literal: true

module Api
  module V1
    module Admin
      class DrivesController < ApiController
        before_action :authenticate_user!
        load_and_authorize_resource :drive

        def index
          drives = Drive.all
          render_success(data: { drives: serialize_resource(drives, DriveSerializer) },
                         message: I18n.t('index.success', model_name: 'Drive'))
        end

        def create
          drive = Drive.new(drive_params.merge(created_by_id: current_user.id, updated_by_id: current_user.id,
                                               organization_id: current_user.organization_id))

          if drive.save
            problem = Problem.find(params[:problem_id])
            DrivesProblem.create(drive_id: drive.id, problem_id: problem.id)
            render_success(data: { drive: serialize_resource(drive, DriveSerializer) },
                           message: I18n.t('create.success', model_name: 'Drive'))
          else
            render_error(message: drive.errors.messages, status: 400)
          end
        end

        def update
          drive = Drive.find(params[:id])
          if drive.update(drive_params.merge(created_by_id: current_user.id, updated_by_id: current_user.id,
                                             organization_id: current_user.organization_id))

            render_success(data: { drive: serialize_resource(drive, DriveSerializer) },
                           message: I18n.t('update.success', model_name: 'Drive'))
          else
            render_error(message: I18n.t(drive.errors.messages, model_name: 'Drive'), status: 400)
          end
        end

        def show
          drive = Drive.find(params[:id])

          render_success(data: { drive: serialize_resource(drive, DriveSerializer) },
                         message: I18n.t('show.success', model_name: 'Drive'))
        end

        private
        
        def drive_params
          params.permit(:name, :description, :start_time, :end_time)
        end
      end
    end
  end
end
