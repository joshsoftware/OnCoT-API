# frozen_string_literal: true

module Api
  module V1
    class CandidateResultsController < ApiController
      before_action :find_data
      def show
        passed = @test_case_results.select { |test_case_result| test_case_result.is_passed = true }.map(&:test_case)
        failed = @test_case_results.select { |test_case_result| test_case_result.is_passed = false }.map(&:test_case)
        render_success(data: { code: @submission.answer, passed: passed, failed: failed })
      end

      private

      def find_data
        drives_candidate = DrivesCandidate.find_by(candidate_id: params[:id], drive_id: params[:drife_id])
        submission_id = find_max_submission_id(drives_candidate.id)
        @submission = Submission.find(submission_id)
        @test_case_results = TestCaseResult.where(submission_id: @submission.id)
      end

      def find_max_submission_id(id)
        submissions = Submission.get_submissions(id, params[:problem_id])
        marks = submissions.map(&:marks)
        submissions[marks.find_index(marks.max)].submission_id
      end
    end
  end
end
