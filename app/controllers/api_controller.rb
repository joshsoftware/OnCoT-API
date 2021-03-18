# frozen_string_literal: true

class ApiController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :error_render_method

  def render_error(message: nil, status: 404)
    render json: message, status: status
  end

  def error_render_method
    render_error(message: 'Record not found', status: 404)
  end

  def render_success(data: nil, message: nil)
    render json: { data: data, message: message }, status: 200
  end

  def serialize_resource(resources, serializer, root = nil, extra = {})
    opts = { each_serializer: serializer, root: root }.merge(extra)
    ActiveModelSerializers::SerializableResource.new(resources, opts) if resources
  end
end
