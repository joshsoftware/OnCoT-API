# frozen_string_literal: true

class ProblemSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :created_at, :updated_at, :created_by_id, :updated_by_id,
             :organization_id, :submission_count

  has_many :drives_problems
end
