# frozen_string_literal: true

class ProblemSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :created_at, :updated_at, :created_by_id, :updated_by_id, :drife_ids,
             :organization_id
end
