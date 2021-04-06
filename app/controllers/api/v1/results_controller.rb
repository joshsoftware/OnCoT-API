# frozen_string_literal: true

module Api
  module V1
    class ResultsController < ApiController
      include DriveResult::ClassMethods
      def show
        result = fetch_results(params[:problem_id], params[:id])
        render_success(data: { candidate_id: result.first, score: result[1], end_time: result[2] },
                       message: I18n.t('success.message'))
      end
    end
  end
end
