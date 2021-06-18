# frozen_string_literal: true

class SnapshotSerializer < ActiveModel::Serializer
  attributes :id, :image_url, :created_at, :candidate_name

  def candidate_name
    candidate = object.drives_candidate.candidate
    [candidate.first_name, candidate.last_name].join(' ')
  end
end
