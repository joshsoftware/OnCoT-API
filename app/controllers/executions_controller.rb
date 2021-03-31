# frozen_string_literal: true

class ExecutionsController < ApiController
  def create
    parameter = { stdin: params[:stdin], source_code: params[:source_code],
                  language_id: params[:language_id] }
    headers = { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    response = JudgeZeroApi.new(parameter, headers).post('/submissions/?base64_encoded=false&wait=true')
    body = JSON.parse(response.body)
    render_success(data: { stdout: body['stdout'], stderr: body['stderr'], status: body['status']['description'] },
                   message: I18n.t('success.message'))
  end
end
