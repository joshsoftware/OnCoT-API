# frozen_string_literal: true

class ApiController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :error_render_method

  def error_render_method
    render_error(message: 'Record not found', status: :not_found)
  end

  def render_success(data: nil, message: nil)
    render json: { data: data, message: message }, status: 200
  end

  def render_error(message: nil)
    render json: message, status: 400
  end

  def serialize_resource(resources, serializer, root = nil, extra = {})
    opts = { each_serializer: serializer, root: root }.merge(extra)
    ActiveModelSerializers::SerializableResource.new(resources, opts) if resources
  end
end
