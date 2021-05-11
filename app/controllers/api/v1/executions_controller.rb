# frozen_string_literal: true

module Api
  module V1
    class ExecutionsController < ApiController
      def submission_token
        parameter = {
          source_code: params[:source_code],
          language_id: params[:language_id],
          stdin: params[:stdin],
          callback_url: "#{callback_url}?room=#{params[:room]}"
        }

        body = JudgeZeroApi.
          new(parameter).
          post('/submissions/?base64_encoded=false&wait=false')

        if body['token']
          render_success(
            data: { token: body['token'] },
            message: I18n.t('success.message')
          )
        else
          render_error(message: I18n.t('not_found.message'), status: 404)
        end
      end

      def submission_status
        token = params[:id]
        body = JudgeZeroApi.new({}).get("/submissions/#{token}")
        render_success(data: body, message: I18n.t('success.message'))
      end

      def submission_result
        ActionCable.server.broadcast(
          params[:room],
          {
            stdout: Base64.decode64(params[:stdout].to_s),
            time: params[:time],
            memory: params[:memory],
            stderr: Base64.decode64(params[:stderr].to_s),
            token: params[:token],
            compile_output: Base64.decode64(params[:compile_output].to_s),
            message: Base64.decode64(params[:message].to_s),
            status: params[:status]
          }
        )
      end

      private

        def callback_url
          "#{ENV['SERVER_URL']}/executions/submission_result"
        end
    end
  end
end
