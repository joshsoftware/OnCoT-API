# frozen_string_literal: true

module Api
  module V1
    class CandidateResultsController < ApiController
      before_action :load_submission

      def show
        passed = TestCase.joins(:test_case_result).where(test_case_result: { is_passed: true, submission_id: @submission.id })
        failed = TestCase.joins(:test_case_result).where(test_case_result: { is_passed: false, submission_id: @submission.id })
        code = @submission.answer
        render_success(data: { code: code, passed: passed, failed: failed })
      end

      private

      def load_submission
        drives_candidate = DrivesCandidate.find_by(candidate_id: params[:id], drive_id: params[:drife_id])
        @submission = drives_candidate.submissions.order('total_marks desc').first
      end
    end
  end
end
