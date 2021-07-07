# frozen_string_literal: true

module Api
  module V1
    class ProblemsController < ApiController
      before_action :load_drive

      def index
        drives_problems = DrivesProblem.where(drive_id: @drive.id)
        problems = []
        drives_problems.each do |drives_problem|
          problems.push(drives_problem.problem)
        end
        render_success(data: problems, message: I18n.t('success.message'))
      end

      private

      def load_drive
        @drive = Drive.find_by(id: params[:id])
        render json: { data: {}, message: I18n.t('not_found.message') }, status: status unless @drive
      end
    end
  end
end
