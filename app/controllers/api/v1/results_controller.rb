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
          csv << %w[First_name Last_name Email Score]
          @drives_candidates.each do |drives_candidate|
            candidate = drives_candidate.candidate
            csv << [candidate.first_name, candidate.last_name, candidate.email, drives_candidate.score]
          end
        end
      end

      private

      def find_drive_candidates
        drive = Drive.find(params[:drife_id])
        @drives_candidates = drive.drives_candidates
      end
    end
  end
end
