# frozen_string_literal: true

module Api
  module V1
    class ExecutionsController < ApiController
      def submission_token
        headers = { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
        parameter = { source_code: params[:source_code], language_id: params[:language_id] }
        response = JudgeZeroApi.new(parameter, headers).post('/submissions/?base64_encoded=false&wait=false')
        token = JSON.parse(response.body)['token']
        render_success(data: { token: token }, message: I18n.t('success.message'))
      end

      def submission_status
        token = params[:id]
        response = JudgeZeroApi.new({}).get("/submissions/#{token}")
        body = JSON.parse(response.body)
        render_success(data: body, message: I18n.t('success.message'))
      end
    end
  end
end
