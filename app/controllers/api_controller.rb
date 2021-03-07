class ApiController < ActionController::API
<<<<<<< HEAD

  def render_success(data, message)
    render json: { data: data, message: message }, status: 200
  end

  def render_error(message, status)
    status = Rack::Utils::SYMBOL_TO_STATUS_CODE[status] if status.is_a? Symbol
    render json: { message: message }, status: status
=======
  def render_success(data: nil, message: nil)
    render json: { data: data, message: message }, status: 200
  end

  def render_error(message: nil)
    render json: message, status: 400
>>>>>>> candidate_API
  end
end
