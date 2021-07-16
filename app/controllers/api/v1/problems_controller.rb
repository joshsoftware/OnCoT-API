# frozen_string_literal: true

module Api
  module V1
    class ProblemsController < ApiController
      before_action :load_drive

      def index
        drives_problems = DrivesProblem.where(drive_id: @drive.id)
        problems = Problem.where(id: drives_problems.collect(&:problem_id))
        render_success(data: serialize_resource(problems, ProblemDetailsSerializer),
                       message: I18n.t('success.message'))
      end

      private

      def load_drive
        @drive = Drive.find_by(id: params[:id])
        render json: { data: {}, message: I18n.t('not_found.message') }, status: status unless @drive
      end
    end
  end
end
