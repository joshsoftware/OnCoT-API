# frozen_string_literal: true

require 'json_helpers'
module Api
  module V1
    class ExecutionsController < ApiController
      include JsonHelpers
      def submission_token
        parameter = { source_code: params[:source_code], language_id: params[:language_id] }
        body = json(JudgeZeroApi.new(parameter).post('/submissions/?base64_encoded=false&wait=false'))
        render_success(data: { token: body['token'] }, message: I18n.t('success.message'))
      end

      def submission_status
        token = params[:id]
        body = json(JudgeZeroApi.new({}).get("/submissions/#{token}"))
        render_success(data: body, message: I18n.t('success.message'))
      end
    end
  end
end
