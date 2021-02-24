require 'http'

class StatusesController < ApplicationController
  def index
    response = JudgeZeroApi.new.get('/statuses')
    render json: response
  end
end