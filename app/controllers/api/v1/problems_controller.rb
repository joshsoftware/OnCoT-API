# frozen_string_literal: true

module Api
  module V1
    class ProblemsController < ApiController
      before_action :load_drive

      def index
        drives_problems = DrivesProblem.where(drive_id: @drive.id)
        render_success(data: drives_problems, message: I18n.t('success.message'))
      end

      private

      def load_drive
        @drive = Drive.find(params[:id])
      end
    end
  end
end
