# frozen_string_literal: true

class SubmissionJob < ApplicationJob
  def perform(submission_id)
    @submission = Submission.find submission_id
    total_marks = create_test_case_result
    TestCaseResult.where(submission_id: @submission.id).collect(&:is_passed)
    @submission.update_columns(total_marks: total_marks, status: 'accepted')
    calculate_result
  end

  def create_test_case_result
    total_marks = 0
    test_cases = TestCase.where(problem_id: @submission.problem_id)
    test_cases.each do |testcase|
      # TODO
      # for compilation error, do not execute further test cases
      status, output = run_testcase(testcase)
      TestCaseResult.create(is_passed: status, submission_id: @submission.id,
                            test_case_id: testcase.id, output: output)
      total_marks += testcase.marks if status
    end
    total_marks
  end

  def run_testcase(testcase)
    parameter = { stdin: testcase.input, expected_output: testcase.output, source_code: @submission.answer,
                  language_id: @submission.lang_code }
    body = JudgeZeroApi.new(parameter).post('/submissions/?base64_encoded=false&wait=true')
    Rails.logger.info body
    [body['status'] && body['status']['description'] == 'Accepted', body['stdout']]
  end

  def calculate_result
    drives_candidate = @submission.drives_candidate
    problems = drives_candidate.drive.problems
    score = 0
    problems.each do |problem|
      submissions = Submission.where(drives_candidate_id: drives_candidate.id, problem_id: problem.id)
      highest_submission = submissions.order('total_marks desc').first
      score += highest_submission.total_marks
    end
    drives_candidate.update(score: score)
  end
end
