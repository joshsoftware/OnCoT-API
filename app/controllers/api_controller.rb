# frozen_string_literal: true

class ApiController < ActionController::API
  def render_success(data: nil, message: nil)
    render json: { data: data, message: message }, status: 200
  end

  def render_error(message: nil)
    render json: message, status: 400
  end
end
