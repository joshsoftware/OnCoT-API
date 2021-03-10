# frozen_string_literal: true

module Api
  module V1
    module Admin
      class ProblemsController < ApiController
        def create
          problem = Problem.new(problem_params)
          if problem.save
            render_success(data: { problem: serialize_resource(problem, ProblemSerializer) },
                           message: I18n.t('create.success', model_name: Problem))
          else
            render_error(message: I18n.t('create.error', model_name: Problem))
          end
        end

        def index
          problems = Problem.all

          if problems
            render_success(data: { problems: serialize_resource(problems, ProblemSerializer) },
                           message: I18n.t('index.success', model_name: Problem))
          else
            render_error(message: I18n.t('index.error', model_name: Problem))
          end
        end

        def show
          id = params[:id]
          problem = Problem.get_problem(id)
          if problem
            render_success(data: { problem: serialize_resource(problem, ProblemSerializer) },
                           message: I18n.t('show.success', model_name: Problem))
          else
            render_error(message: I18n.t('show.error', model_name: Problem))
          end
        end

        def update
          id = params[:id]
          problem = Problem.get_problem(id)

          if problem.update(problem_params)
            render_success(data: { problem: serialize_resource(problem, ProblemSerializer) },
                           message: I18n.t('update.success', model_name: Problem))
          else
            render_error(message: I18n.t('update.error', model_name: Problem))
          end
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
