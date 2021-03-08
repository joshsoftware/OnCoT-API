class LanguagesController < ApplicationController
  def index
    response = JudgeZeroApi.new.get('/languages')
    body = JSON.parse(response.body)
    render json: body
  end

  def all
    response = JudgeZeroApi.new.get('/languages/all')
    body = JSON.parse(response.body)
    render json: body
  end

  def show
    id = params[:id]
    response = JudgeZeroApi.new(params[:id]).get('/languages')
    render json: response.to_s
  end
end
