class ResultsController < ApiController
  def show
    candidate_id = params[:candidate_id]
    problem_id = params[:id]
    final_marks = 0
    submissions = Submission.where(candidate_id: candidate_id, problem_id: problem_id)
    if submissions.length > 0
      submissions.each do |submission|
        test_case_results = TestCaseResult.where(submission_id: submission.id)
        marks = 0
        test_case_results.each do |test_case_result|
          if test_case_result.is_passed == true
            test_case = TestCase.find_by(id: test_case_result.test_case_id)
            marks += test_case.marks
          end
        end
        final_marks = marks if final_marks < marks
      end
      render_success(data: final_marks, message: I18n.t('success.message'))
    else
      render_error(message: I18n.t('not_found.message'))
    end
  end
end
