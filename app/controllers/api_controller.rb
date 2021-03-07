class ApiController < ActionController::API

  def render_success(data:nil, message:nil)
    render json: { data: data, message: message }, status: 200
  end

  def render_error(message, status)
    status = Rack::Utils::SYMBOL_TO_STATUS_CODE[status] if status.is_a? Symbol
    render json: { message: message }, status: status
  end
end
