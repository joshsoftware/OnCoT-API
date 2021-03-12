# frozen_string_literal: true

module Api
  module V1
    module Admin
      class ProblemsController < ApiController
        def create
          problem = Problem.new(problem_params)
          problem.save
          render_success(data: { problem: serialize_resource(problem, ProblemSerializer) },
                         message: I18n.t('create.success', model_name: Problem))
        end

        def index
          problems = Problem.paginate(page: params[:page], per_page: 3)

          render_success(data: { problems: serialize_resource(problems, ProblemSerializer) },
                         message: I18n.t('index.success', model_name: Problem))
        end

        def show
          problem = Problem.find(params[:id])

          render_success(data: { problem: serialize_resource(problem, ProblemSerializer) },
                         message: I18n.t('show.success', model_name: Problem))
        end

        def update
          problem = Problem.find(params[:id])

          problem.update(problem_params)
          render_success(data: { problem: serialize_resource(problem, ProblemSerializer) },
                         message: I18n.t('update.success', model_name: Problem))
        end

        private

        def problem_params
          params.permit(:id, :title, :description, :created_by_id, :updated_by_id, :organization_id, :created_at, :updated_at,
                        :drive_id)
        end
      end
    end
  end
end
