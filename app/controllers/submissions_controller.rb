# frozen_string_literal: true
class SubmissionsController < ApiController
  def create
    submission_count = params[:submission_count]
    if submission_count.positive?
      total = 0
      passed = 0
      marks = 0
      if (submission = Submission.create(problem_id: params[:id], candidate_id: params[:candidate_id],
                                         answer: params[:source_code]))
        submission_count -= 1
      else
        render_error(message: I18n.t('submission.not_created.message'))
      end

      test_cases = TestCase.where(problem_id: params[:id])
      test_cases.each do |testcase|
        parameter = { stdin: testcase.input, expected_output: testcase.output, source_code: params[:source_code],
                      language_id: params[:language_id] }

        headers = { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
        response = JudgeZeroApi.new(parameter, headers).post('/submissions/?base64_encoded=false&wait=true')
        body = JSON.parse(response.body)

        if body['status']['description'] == 'Accepted'
          flag = true
          passed += 1
        else
          flag = false
        end

        TestCaseResult.create(is_passed: flag, submission_id: submission.id,
                              test_case_id: testcase.id)
        total += 1
      end
      render_success(data: { passed_testcases: passed, total_testcases: total,
                             submission_count: submission_count }, message: I18n.t('success.message'))
    else
      render_error(message: I18n.t('submission.limit_exceed.message'))
    end
  end
end
