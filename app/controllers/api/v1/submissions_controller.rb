# frozen_string_literal: true

module Api
  module V1
    class SubmissionsController < ApiController
      before_action :find_data

      def create
        total_submission = @drives_candidate.submissions.count
        if total_submission < @submission_count
          submission = create_submission
          total_marks = create_test_case_result(submission.id)
          testcases = TestCaseResult.where(submission_id: submission.id).collect(&:is_passed)
          submission.update_attribute(:total_marks, total_marks)

          render_success(data: { passed_testcases: testcases.count(true), total_testcases: testcases.count,
                                 submission_count: total_submission + 1 },
                         message: I18n.t('success.message'))
        else
          render_error(message: I18n.t('submission.limit_exceed.message'))
        end
      end

      private

      def find_data
        @submission_count = Problem.find(params[:id]).submission_count
        @drives_candidate = DrivesCandidate.find_by(candidate_id: params[:candidate_id], drive_id: params[:drive_id])
      end

      def create_submission
        if (submission = Submission.create(problem_id: params[:id], drives_candidate_id: @drives_candidate.id,
                                           answer: params[:source_code], lang_code: params[:language_id]))
          submission
        else
          render_error(message: I18n.t('submission.not_created.message'))
        end
      end

      def create_test_case_result(submission_id)
        total_marks = 0
        test_cases = TestCase.where(problem_id: params[:id])
        test_cases.each do |testcase|
          status = get_status(testcase)
          TestCaseResult.create(is_passed: status, submission_id: submission_id,
                                test_case_id: testcase.id)
          total_marks += testcase.marks if status
        end
        total_marks
      end

      def get_status(testcase)
        parameter = { stdin: testcase.input, expected_output: testcase.output, source_code: params[:source_code],
                      language_id: params[:language_id] }
        body = JudgeZeroApi.new(parameter).post('/submissions/?base64_encoded=false&wait=true')
        body['status']['description'] == 'Accepted'
      end
    end
  end
end
