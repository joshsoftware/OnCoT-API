# frozen_string_literal: true

class SnapshotSerializer < ActiveModel::Serializer
  attributes :id, :url, :drive_id, :candidate_id
end
