# frozen_string_literal: true

module Api
  module V1
    class SubmissionsController < ApiController
      before_action :find_data
      def create
        if @drives_candidate.submissions.count < @submission_count
          submission = create_submission(@drives_candidate.submissions.count)
          result = find_result(submission.first)
          render_success(data: { passed_testcases: result[0], total_testcases: result[1], submisiion_count: submission[1] },
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

      def create_submission(submission_count)
        if (submission = Submission.create(problem_id: params[:id], drives_candidate_id: @drives_candidate.id,
                                           answer: params[:source_code]))
          [submission.id, @submission_count - submission_count - 1]
        else
          render_error(message: I18n.t('submission.not_created.message'))
        end
      end

      def find_result(submission_id)
        total = 0
        passed = 0
        test_cases = TestCase.where(problem_id: params[:id])
        test_cases.each do |testcase|
          status = get_status(testcase, passed)
          passed = status[1]
          TestCaseResult.create(is_passed: status.first, submission_id: submission_id,
                                test_case_id: testcase.id)
          total += 1
        end
        [passed, total]
      end

      def get_status(testcase, passed)
        parameter = { stdin: testcase.input, expected_output: testcase.output, source_code: params[:source_code],
                      language_id: params[:language_id] }
        body = JudgeZeroApi.new(parameter).post('/submissions/?base64_encoded=false&wait=true')
        if body['status']['description'] == 'Accepted'
          flag = true
          passed += 1
        end
        [flag, passed]
      end
    end
  end
end
