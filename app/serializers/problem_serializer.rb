class ProblemSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :created_at, :updated_at, :created_by_id, :updated_by_id, :drive_id, :organization_id
end
