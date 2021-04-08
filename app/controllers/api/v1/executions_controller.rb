# frozen_string_literal: true

module Api
  module V1
    class ExecutionsController < ApiController
      def submission_token
        parameter = { source_code: params[:source_code], language_id: params[:language_id] }
        body = JudgeZeroApi.new(parameter).post('/submissions/?base64_encoded=false&wait=false')
        render_success(data: { token: body['token'] }, message: I18n.t('success.message'))
      end

      def submission_status
        token = params[:id]
        body = JudgeZeroApi.new({}).get("/submissions/#{token}")
        render_success(data: body, message: I18n.t('success.message'))
      end
    end
  end
end
