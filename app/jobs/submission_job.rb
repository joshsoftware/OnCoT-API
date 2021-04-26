# frozen_string_literal: true

class SubmissionJob < ApplicationJob
  def perform(submission_id)
    @submission = Submission.find submission_id
    total_marks = create_test_case_result
    testcases = TestCaseResult.where(submission_id: @submission.id).collect(&:is_passed)
    @submission.update_columns(total_marks: total_marks, status: 'accepted')
  end

  def create_test_case_result
    total_marks = 0
    test_cases = TestCase.where(problem_id: @submission.problem_id)
    test_cases.each do |testcase|
      status = get_status(testcase)
      TestCaseResult.create(is_passed: status, submission_id: @submission.id,
                            test_case_id: testcase.id)
      total_marks += testcase.marks if status
    end
    total_marks
  end

  def get_status(testcase)
    parameter = { stdin: testcase.input, expected_output: testcase.output, source_code: @submission.answer,
                  language_id: @submission.lang_code }
    body = JudgeZeroApi.new(parameter).post('/submissions/?base64_encoded=false&wait=true')
    body['status']['description'] == 'Accepted'
  end
end
