# frozen_string_literal: true

module Api
  module V1
    class ResultsController < ApiController
      def index
        drive = Drive.find(params[:drife_id])
        drives_candidates = drive.drives_candidates
        render_success(data: serialize_resource(drives_candidates, DrivesCandidateSerializer))
      end
    end
  end
end
