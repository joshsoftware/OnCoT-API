# frozen_string_literal: true

module Api
  module V1
    class CodesController < ApiController
      before_action :find_drives_candidate, :find_problem
      before_action :find_code, only: %i[show]

      def create
        code = Code.find_or_initialize_by(drives_candidate_id: @drives_candidate.id, problem_id: @problem.id)
        code.save
        code.update(answer: params[:answer], lang_code: params[:language_id])
        if code
          render_success(data: { code: serialize_resource(code, CodeSerializer) }, message: I18n.t('success.message'))
        else
          render_error(message: code.errors.messages)
        end
      end

      def show
        render_success(data: { code: serialize_resource(@code, CodeSerializer) }, message: I18n.t('success.message'))
      end

      private

      def find_code
        @code = Code.find_by(drives_candidate_id: @drives_candidate.id,
                             problem_id: @problem.id)
        render json: { data: {}, message: I18n.t('not_found.message') } unless @code
      end

      def find_drives_candidate
        @drives_candidate = DrivesCandidate.find_by(token: params[:token])
        render json: { data: {}, message: I18n.t('not_found.message') } unless @drives_candidate
      end

      def find_problem
        @problem = Problem.find_by(id: params[:problem_id])
        render json: { data: {}, message: I18n.t('not_found.message') } unless @problem
      end
    end
  end
end
