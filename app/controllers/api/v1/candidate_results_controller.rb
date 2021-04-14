# frozen_string_literal: true

module Api
  module V1
    class CandidateResultsController < ApiController
      before_action :find_data
      def show
        passed = []
        failed = []
        # passed  = @test_case_results.where(is_passed == true)
        # failed = @test_case_results.where(is_passed == false)
        @test_case_results.each do |test_case_result|
          if test_case_result.is_passed == true
            passed << test_case_result.test_case
          else
            failed << test_case_result.test_case
          end
        end
        render_success(data: { code: @submission.answer, passed: passed, failed: failed })
      end

      def find_data
        drives_candidate = DrivesCandidate.find_by(candidate_id: params[:id], drive_id: params[:drife_id])
        submits = Submission.joins(test_case_results: [:test_case]).where(drives_candidate_id: drives_candidate.id,
                                                                          problem_id: params[:problem_id],
                                                                          test_case_results: { is_passed: true })
        submits = submits.select('submissions.id as submission_id, sum(test_cases.marks) as marks').group('submissions.id')
        arr = submits.map(&:marks)
        max_mark = arr.max
        idd = submits[arr.find_index(max_mark)].submission_id
        @submission = Submission.find(idd)
        @test_case_results = TestCaseResult.where(submission_id: @submission.id)
      end
    end
  end
end
