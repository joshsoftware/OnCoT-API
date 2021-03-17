# frozen_string_literal: true

class ApiController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :error_render_method

  def error_render_method
    render_error(message: 'Record not found', status: 404)
  end

  def render_success(data: nil, message: nil, status: 200)
    render json: { data: data, message: message }, status: status
  end

  def render_error(message: nil, status: 400)
    render json: message, status: status
  end
end
