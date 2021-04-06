# frozen_string_literal: true

module Api
  module V1
    module Admin
      class TestCasesController < ApiController
        before_action :authenticate_user!
        load_and_authorize_resource

        def create
          test_case = TestCase.new(test_case_params.merge(created_by_id: current_user.id,
                                                          updated_by_id: current_user.id))
          if test_case.save
            render_success(data: { test_case: serialize_resource(test_case, TestcaseSerializer) },
                           message: I18n.t('create.success', model_name: TestCase))
          else
            render_error(message: test_case.errors.messages, status: 400)
          end
        end

        def index
          problem = Problem.find(params[:problem_id])
          test_cases = problem.test_cases
          if test_cases
            render_success(data: { test_cases: serialize_resource(test_cases, TestcaseSerializer) },
                           message: I18n.t('index.success', model_name: TestCase))
          else
            render_error(message: test_cases.errors.messages, status: 400)
          end
        end

        def show
          test_case = TestCase.find(params[:id])

          render_success(data: { test_case: serialize_resource(test_case, TestcaseSerializer) },
                         message: I18n.t('show.success', model_name: TestCase))
        end

        def update
          test_case = TestCase.find(params[:id])

          if test_case.update(test_case_params.merge(created_by_id: current_user.id,
                                                     updated_by_id: current_user.id))
            render_success(data: { test_case: serialize_resource(test_case, TestcaseSerializer) },
                           message: I18n.t('update.success', model_name: TestCase))
          else
            render_error(message: test_case.errors.messages, status: 400)
          end
        end

        private

        def test_case_params
          params.permit(:id, :input, :output, :marks, :problem_id)
        end
      end
    end
  end
end
