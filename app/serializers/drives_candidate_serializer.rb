# frozen_string_literal: true

class DrivesCandidateSerializer < ActiveModel::Serializer
  attributes :candidate_id, :first_name, :last_name, :email, :score

  def first_name
    object.candidate.first_name
  end

  def last_name
    object.candidate.last_name
  end

  def email
    object.candidate.email
  end

  def end_times
    object.completed_at.present? ? object.completed_at.iso8601 : object.end_time.iso8601
  end
end
