# frozen_string_literal: true

require 'csv'
module Api
  module V1
    class ResultsController < ApiController
      before_action :find_drive_candidates
      def index
        render_success(data: serialize_resource(@drives_candidates, DrivesCandidateSerializer),
                       message: I18n.t('success.message', model_name: DrivesCandidate))
      end

      def csv_result
        if write_csv_file
          render_success(message: I18n.t('success.message'))
        else
          render_error(message: I18n.t('not_found.message'))
        end
      end

      private

      def find_drive_candidates
        drive = Drive.find(params[:drife_id])
        @drives_candidates = drive.drives_candidates
      end

      def write_csv_file
        CSV.open('result_file.csv', 'w') do |csv|
          csv << ['First Name', 'Last Name', 'Email', 'Score', 'Passed Testcases', 'Passed Testcase Count']
          @drives_candidates.each do |drives_candidate|
            candidate = drives_candidate.candidate
            submission = drives_candidate.submissions.order('total_marks desc').first
            if submission
              passed = find_passed_testcases(submission.id)
              csv << [candidate.first_name, candidate.last_name, candidate.email, drives_candidate.score, passed.first,
                      passed[1]]
            end
          end
        end
      end

      def find_max_marks_submission_id(id)
        submissions = Submission.submissions_with_passed_testcases(id, params[:problem_id])
        marks = submissions.map(&:marks)

        submissions[marks.find_index(marks.max)].submission_id
      end

      def find_passed_testcases(submission_id)
        passed_test_cases = TestCase.joins(:test_case_result).where(test_case_result: { is_passed: true, submission_id: submission_id })
        passed_test_cases_details = passed_test_cases.select('id', 'output', 'input').to_a
        [passed_test_cases_details, passed_test_cases.count]
      end
    end
  end
end
