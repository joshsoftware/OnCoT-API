# frozen_string_literal: true

# frozen_string_literal: true

class DrivesCandidateSerializer < ActiveModel::Serializer
  attributes :candidate_id, :first_name, :last_name, :email, :score, :end_times

  def end_times
    object.completed_at.present? ? object.completed_at.iso8601 : object.end_time.iso8601
  end

  def first_name
    candidate = find_candidate
    candidate.first_name
  end

  def last_name
    candidate = find_candidate
    candidate.last_name
  end

  def email
    candidate = find_candidate
    candidate.email
  end

  def find_candidate
    Candidate.find(object.candidate_id)
  end
end
