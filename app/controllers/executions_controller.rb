# frozen_string_literal: true

class ExecutionsController < ApiController
  def submission_token
    response = JudgeZeroApi.new(params).post('/submissions/?base64_encoded=false&wait=false')
    token = JSON.parse(response.body)['token']
    if token
      render_success(data: { token: token }, message: I18n.t('ok.message'))
    else
      render_error(message: I18n.t('not_found.message'), status: :not_found)
    end
  end

  def submission_status
    token = params[:id]
    response = JudgeZeroApi.new(params).get("/submissions/#{token}")
    body = JSON.parse(response.body)
    if body['error']
      render_error(message: body['error'], status: :not_found)
    else
      render_success(data: body, message: I18n.t('ok.message'))
    end
  end
end
