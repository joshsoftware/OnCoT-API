# frozen_string_literal: true

class DrivesCandidateSerializer < ActiveModel::Serializer
  attributes :candidate_id, :score, :end_times

  def end_times
    object.completed_at.present? ? object.completed_at.iso8601 : object.end_time.iso8601
  end
end
