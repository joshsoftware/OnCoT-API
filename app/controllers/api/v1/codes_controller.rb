# frozen_string_literal: true

module Api
  module V1
    class CodesController < ApiController
      before_action :find_drives_candidate, :find_drives_problem
      before_action :find_code, only: %i[show update]

      def create
        code = Code.new(answer: params[:answer],
                drives_candidate_id: @drives_candidate.id,
                drives_problem_id: @drives_problem.id,
                lang_code: params[:language_id]
              )
        if code.save
          render_success(data: {code: serialize_resource(code, CodeSerializer) }, message: I18n.t('success.message'))
        else
          render_error(message: code.errors.messages)
        end
      end

      def update
        if @code.update(answer: params[:answer], lang_code: params[:language_id] )
          render_success(data: {code: serialize_resource(@code, CodeSerializer) }, message: I18n.t('success.message'))
        else
          render_error(message: code.errors.messages)
        end
      end

      def show
        render_success(data: {code: serialize_resource(@code, CodeSerializer) }, message: I18n.t('success.message'))
      end

      private

      def find_code
        @code = Code.find_by(drives_candidate_id: @drives_candidate.id,
                      drives_problem_id: @drives_problem.id)
        render_error(message: I18n.t('not_found.message')) unless @code
      end

      def find_drives_candidate
        @drives_candidate = DrivesCandidate.find_by(token: params[:token])
        render_error(message: I18n.t('not_found.message')) unless @drives_candidate
      end

      def find_drives_problem
        problem = Problem.find(params[:problem_id])
        @drives_problem = DrivesProblem.find_by(drive_id: @drives_candidate.drive.id, problem_id: problem.id)
        render_error(message: I18n.t('not_found.message')) unless @drives_candidate
      end
    end
  end
end
