class ApiController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def record_not_found
    render json: { message: '404 Not found' }, status: 404
  end

  def render_success(data: nil, message: nil)
    render json: { message: message, data: data }, status: 200
  end

  def render_error(message: nil)
    render json: message, status: 400
  end

end
