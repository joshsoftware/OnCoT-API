class ApiController < ActionController::API
  def render_success(data: nil, message: nil, status: 200)
    render json: { data: data, message: message }, status: status
  end

  def render_error(message: nil)
    render json: message, status: 400
  end

  def serialize_resource(resources, serializer, root = nil, extra = {})
   opts = { each_serializer: serializer, root: root }.merge(extra)
   ActiveModelSerializers::SerializableResource.new(resources, opts) if resources
  end
end
