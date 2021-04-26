# frozen_string_literal: true

# == Schema Information
#
# Table name: drives_candidates
#
#  id            :bigint           not null, primary key
#  drive_id      :bigint
#  candidate_id  :bigint
#  token         :string
#  email_sent_at :datetime
#  start_time    :datetime
#  end_time      :datetime
#  invite_status :string
#  is_qualified  :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  completed_at  :datetime
#  score         :integer
#
class DrivesCandidateSerializer < ActiveModel::Serializer
  attributes :candidate_id, :first_name, :last_name, :email, :score, :end_times

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
    return object.completed_at&.iso8601 if object.completed_at.present?

    object.end_time&.iso8601
  end
end
