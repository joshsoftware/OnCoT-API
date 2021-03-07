class ExecutionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def submission_token
    headers={"Content-Type": "application/json"}
    response = JudgeZeroApi.new(params,headers).post("/submissions/?base64_encoded=false&wait=false")
    @token = JSON.parse(response.body)["token"]
    render json:{token:@token}
  end

  def submission_status
    token=params[:token]
    response = JudgeZeroApi.new(params).get("/submissions/#{token}")
    body = JSON.parse(response.body)
    render json:body
  end
end
