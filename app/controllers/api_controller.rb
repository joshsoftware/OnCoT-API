# frozen_string_literal: true

class ApiController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def render_error_method
    render_error(message: '404 Not found', status: 404)
  end

  def render_success(data: nil, message: nil, status: 200)
    render json: { data: data, message: message }, status: status
  end

  def render_error(message: nil, status: 400)
    render json: message, status: status
  end
end
