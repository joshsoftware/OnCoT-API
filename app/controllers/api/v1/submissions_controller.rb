# frozen_string_literal: true

module Api
  module V1
    class SubmissionsController < ApiController
      def create
        if submission_allowed?
          submission = create_submission
          SubmissionJob.perform_later(submission.id)
          render_success(data: { status: 'processing', submission_id: submission.id },
                         message: I18n.t('success.message'))
        else
          render_error(message: I18n.t('submission.limit_exceed.message'))
        end
      end

      def show
        submission = Submission.where(id: params[:id]).first
        submission_count_left = calculate_remaining_submission_count(submission)
        chk_submission_status(submission, submission_count_left)
      end

      def chk_submission_status # rubocop:disable Metrics/AbcSize
        if submission
          if submission.status == 'accepted'
            testcases = TestCaseResult.where(submission_id: submission.id).collect(&:is_passed)
            render_success(data: { passed_testcases: testcases.count(true), total_testcases: testcases.count,
                                   submission_count: submission_count_left, status: 'accepted' }, message: I18n.t('success.message'))
          else
            render_success(data: { status: 'processing' }, message: I18n.t('success.message'))
          end
        else
          render_error(message: I18n.t('not_found.message'))
        end
      end

      private

      def create_submission
        Submission.create(
          problem_id: params[:id],
          drives_candidate_id: @drives_candidate.id,
          answer: params[:source_code],
          lang_code: params[:language_id]
        )
      end

      def submission_allowed?
        submission_count = Problem.find(params[:id]).submission_count
        @drives_candidate = DrivesCandidate.find_by(candidate_id: params[:candidate_id], drive_id: params[:drive_id])
        @drives_candidate.submissions.count < submission_count && @drives_candidate.end_time >= DateTime.current
      end

      def calculate_remaining_submission_count(submission)
        total_count = submission.problem.submission_count
        drives_candidate = submission.drives_candidate
        total_count - drives_candidate.submissions.count
      end
    end
  end
end
