# frozen_string_literal: true

require 'csv'
module Api
  module V1
    class ResultsController < ApiController
      before_action :find_drive_candidates
      def index
        drives_candidates = @drives_candidates.paginate(page: params[:page], per_page: 10).order('id')
        render_success(data: { result: serialize_resource(drives_candidates, DrivesCandidateSerializer),
                               page: drives_candidates.current_page, pages: drives_candidates.total_pages },
                       message: I18n.t('success.message', model_name: DrivesCandidate))
      end

      def csv_result
        if write_csv_file
          send_file Rails.root.join('result_file.csv')
        else
          render_error(message: I18n.t('not_found.message'))
        end
      end

      private

      def find_drive_candidates
        @drive = Drive.find(params[:drife_id])
        @drives_candidates = @drive.drives_candidates
      end

      def write_csv_file
        CSV.open('result_file.csv', 'w') do |csv|
          problem = @drive.problems.first
          test_case_headers = problem.test_cases.count.times.collect do |index|
            ["Test case #{index + 1} expected output", "Test case #{index + 1} actual output"]
          end.flatten
          csv << ['First Name', 'Last Name', 'Email', 'Score'] + test_case_headers + ['Code']
          @drives_candidates.each do |drives_candidate|
            candidate = drives_candidate.candidate
            submission = drives_candidate.submissions.order('total_marks desc').first
            next unless submission

            test_cases = test_case_results(submission.id)
            csv << [candidate.first_name, candidate.last_name, candidate.email,
                    drives_candidate.score] + test_cases + [submission.answer]
          end
        end
      end

      # def find_max_marks_submission_id(id)
      #   submissions = Submission.submissions_with_passed_testcases(id, params[:problem_id])
      #   marks = submissions.map(&:marks)

      #   submissions[marks.find_index(marks.max)].submission_id
      # end

      def test_case_results(submission_id)
        test_case_results = TestCaseResult.joins(:test_case)
                                          .where(submission_id: submission_id)
        test_case_results.collect do |test_case_result|
          [test_case_result.test_case.output, test_case_result.output]
        end.flatten
      end
    end
  end
end
