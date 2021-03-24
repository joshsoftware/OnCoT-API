# frozen_string_literal: true

class DriveSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :start_time, :end_time, :created_by_id, :updated_by_id, :organization_id
end
