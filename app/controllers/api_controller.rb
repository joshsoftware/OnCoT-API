# frozen_string_literal: true

class ApiController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  rescue_from ActiveRecord::RecordNotFound, with: :error_render_method

  rescue_from CanCan::AccessDenied do |_exception|
    render json: { message: I18n.t('reviewer.error') }, status: 403
  end

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
