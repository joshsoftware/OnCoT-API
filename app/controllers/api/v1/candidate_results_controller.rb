# frozen_string_literal: true

module Api
  module V1
    class CandidateResultsController < ApiController
      before_action :find_data
      def show
        passed = []
        failed = []
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
        @submission = Submission.find(drives_candidate.answer_id)
        @test_case_results = TestCaseResult.where(submission_id: @submission.id)
      end
    end
  end
end
