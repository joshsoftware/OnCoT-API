class ApiController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :error_render_method
 
  def error_render_method
    render_error(message: 'Record not found', status: :not_found)
  end
  
  def render_success(data: nil, message: nil)
    render json: { data: data, message: message }, status: 200
  end
 
  def render_error(message: nil, status: 422)
    render json: message, status: status
  end
 end