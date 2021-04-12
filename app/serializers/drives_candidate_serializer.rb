# frozen_string_literal: true

class DrivesCandidateSerializer < ActiveModel::Serializer
  attributes :candidate_id, :first_name, :last_name, :email, :score, :end_times

  def first_name
    Candidate.find(object.candidate_id).first_name
  end

  def last_name
    Candidate.find(object.candidate_id).last_name
  end

  def email
    Candidate.find(object.candidate_id).email
  end

  def end_times
    object.completed_at.present? ? object.completed_at.iso8601 : object.end_time.iso8601
  end
end
