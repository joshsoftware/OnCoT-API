# frozen_string_literal: true

module Api
  module V1
    class CandidateResultsController < ApiController
      before_action :find_data
      def show
        passed = TestCase.joins(:test_case_result).where(test_case_result: { is_passed: true, submission_id: @submission_id })
        failed = TestCase.joins(:test_case_result).where(test_case_result: { is_passed: false, submission_id: @submission_id })
        code = Submission.find(@submission_id).answer
        render_success(data: { code: code, passed: passed, failed: failed })
      end

      private

      def find_data
        drives_candidate = DrivesCandidate.find_by(candidate_id: params[:id], drive_id: params[:drife_id])
        @submission_id = find_max_submission_id(drives_candidate.id)
      end

      def find_max_submission_id(id)
        submissions = Submission.get_submissions(id, params[:problem_id])
        marks = submissions.map(&:marks)
        submissions[marks.find_index(marks.max)].submission_id
      end
    end
  end
end
