# frozen_string_literal: true

module Api
  module V1
    class ProblemsController < ApiController
      before_action :find_problem
      def index
        if (problem = @drive_problem.problem)
          render_success(data: serialize_single_resource(problem, ProblemDetailsSerializer),
                         message: I18n.t('success.message'))
        else
          render_error(message: I18n.t('not_found.message'), status: 404)
        end
      end

      def find_problem
        @drive_problem = DrivesProblem.find_by(drive_id: params[:id])
        return render_error(message: I18n.t('not_found.message'), status: :not_found) if @drive_problem.blank?
      end
    end
  end
end
