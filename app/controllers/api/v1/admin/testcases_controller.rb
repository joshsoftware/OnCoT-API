# frozen_string_literal: true

module Api
  module V1
    module Admin
      class TestcasesController < ApiController
        def create
          testcase = TestCase.new(testcase_params)
          if testcase.save
            render_success(data: { testcase: serialize_resource(testcase, TestcaseSerializer) },
                           message: I18n.t('create.success', model_name: TestCase))
          else
            render_error(message: testcase.errors.messages, status: 400)
          end
        end

        def index
          testcases = TestCase.paginate(page: params[:page], per_page: 15)

          render_success(data: { testcases: serialize_resource(testcases, TestcaseSerializer) },
                         message: I18n.t('index.success', model_name: TestCase))
        end

        def show
          testcase = TestCase.find(params[:id])

          render_success(data: { testcase: serialize_resource(testcase, TestcaseSerializer) },
                         message: I18n.t('show.success', model_name: TestCase))
        end

        def update
          testcase = TestCase.find(params[:id])

          if testcase.update(testcase_params)
            render_success(data: { testcase: serialize_resource(testcase, TestcaseSerializer) },
                           message: I18n.t('update.success', model_name: TestCase))
          else
            render_error(message: testcase.errors.messages, status: 400)
          end
        end

        private

        def testcase_params
          params.permit(:id, :input, :output, :marks, :problem_id, :created_by_id, :updated_by_id)
        end
      end
    end
  end
end
