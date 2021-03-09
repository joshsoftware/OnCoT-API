# frozen_string_literal: true

module Api
  module V1
    module Admin
      class ProblemsController < ApiController
        def create
          problem = Problem.new(problem_params)
          if problem.save
            render_success(data: { problem: problem }, message: I18n.t('create.success', model_name: Problem))
          else
            render_error(message: problem.errors.full_messages)
          end
        end

        def index
          problems = Problem.all

          if problems
            render_success(data: { problems: problems }, message: I18n.t('index.success', model_name: Problem))
          else
            render_error(message: 'Problems not exist')
          end
        end

        def show
          problem = Problem.find_by(id: params[:id])
          if problem
            render_success(data: { problem: problem }, message: I18n.t('show.success', model_name: Problem))
          else
            render_error(message: 'Problems not exist')
          end
        end

        def update
          problem = Problem.find_by(id: params[:id])
          if problem.update(problem_params)
            render_success(data: { problem: problem }, message: I18n.t('update.success', model_name: Problem))
          else
            render_error(message: 'Update failed')
          end
        end

        def destroy
          problem = Problem.find_by(id: params[:id])
          if problem.destroy
            render_success(message: I18n.t('destroy.success', model_name: Problem))
          else
            render_error(message: 'Deletion failed')
          end
        end

        private

        def problem_params
          params.permit(:title, :description, :created_by_id, :updated_by_id, :organization_id, :created_at, :updated_at,
                        :drive_id)
        end
      end
    end
  end
end
