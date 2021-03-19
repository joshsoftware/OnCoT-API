module Api
  module V1
    module Admin
      class DrivesController < ApiController
        def index
          drives = Drive.all
          render_success(data: { drives: serialize_resource(drives, DriveSerializer) },
                         message: I18n.t('index.success', model_name: 'Drive'))
        end

        def create
          drive = Drive.create(drive_params)
          if drive.save
            render_success(data: { drive: serialize_resource(drive, DriveSerializer) },
                           message: I18n.t('create.success', model_name: 'Drive'))
          else
            render_error(message: I18n.t('create.failed', model_name: 'Drive'))
          end
        end

        def update
          drive = Drive.find(params[:id])
          return unless drive.update(drive_params)

          render_success(data: { drive: serialize_resource(drive, DriveSerializer) },
                         message: I18n.t('update.success', model_name: 'Drive'))
        end

        private

        def drive_params
          params.permit(:name, :description, :start_time, :end_time, :created_by_id, :updated_by_id, :organization_id,
                        :duration)
        end
      end
    end
  end
end
