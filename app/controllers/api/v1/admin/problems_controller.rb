# frozen_string_literal: true

module Api
  module V1
    module Admin
      class ProblemsController < ApiController
        before_action :authenticate_user!
        load_and_authorize_resource

        def create
          problem = Problem.new(problem_params.merge(created_by_id: current_user.id, updated_by_id: current_user.id,
                                                     organization_id: current_user.organization_id))

          if problem.save
            render_success(data: { problem: serialize_resource(problem, ProblemSerializer) },
                           message: I18n.t('create.success', model_name: Problem))
          else
            render_error(message: problem.errors.messages, status: 400)
          end
        end

        def index
          problems = Problem.paginate(page: params[:page], per_page: 10).order('id')

          render_success(data: { problems: serialize_resource(problems, ProblemSerializer),
                                 page: problems.current_page, pages: problems.total_pages },
                         message: I18n.t('index.success', model_name: Problem))
        end

        def problems_list
          problems = Problem.all.order('title')
          render_success(data: { problems: serialize_resource(problems, ProblemsListSerializer) },
                         message: I18n.t('index.success', model_name: Problem))
        end

        def show
          problem = Problem.find(params[:id])

          render_success(data: { problem: serialize_resource(problem, ProblemSerializer) },
                         message: I18n.t('show.success', model_name: Problem))
        end

        def update
          problem = Problem.find(params[:id])

          if problem.update(problem_params.merge(created_by_id: current_user.id, updated_by_id: current_user.id))

            render_success(data: { problem: serialize_resource(problem, ProblemSerializer) },
                           message: I18n.t('update.success', model_name: Problem))
          else
            render_error(message: I18n.t(problem.errors.messages, model_name: Problem), status: 400)
          end
        end

        private

        def problem_params
          params.permit(:id, :title, :description, :drive_id, :submission_count, :time_in_minutes)
        end
      end
    end
  end
end
