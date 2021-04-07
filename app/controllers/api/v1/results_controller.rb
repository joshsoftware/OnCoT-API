# frozen_string_literal: true

module Api
  module V1
    class ResultsController < ApiController
      before_action :find_drive_candidates
      def index
        render_success(data: serialize_resource(@drives_candidates, DrivesCandidateSerializer),
                       message: I18n.t('success.message', model_name: DrivesCandidate))
      end

      private

      def find_drive_candidates
        drive = Drive.find(params[:drife_id])
        @drives_candidates = drive.drives_candidates
      end
    end
  end
end
