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
        CSV.open('result_file.csv', 'w') do |csv|
          csv << ['First Name', 'Last Name', 'Email', 'Score', 'Testcases Passed', 'Passed Testcase Count']
          @drives_candidates.each do |drives_candidate|
            candidate = drives_candidate.candidate
            id = find_max_marks_submission_id(drives_candidate.id)
            passed = TestCase.joins(:test_case_result).where(test_case_result: { is_passed: true, submission_id: id })
            test_cases = passed.select('id', 'output', 'input').to_a
            csv << [candidate.first_name, candidate.last_name, candidate.email, drives_candidate.score, test_cases,
                    passed.count]
          end
        end
      end

      private

      def find_drive_candidates
        drive = Drive.find(params[:drife_id])
        @drives_candidates = drive.drives_candidates
      end

      def find_max_marks_submission_id(id)
        submissions = Submission.submissions_with_passed_testcases(id, params[:problem_id])
        marks = submissions.map(&:marks)
        submissions[marks.find_index(marks.max)].submission_id
      end
    end
  end
end
