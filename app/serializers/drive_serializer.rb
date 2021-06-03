# frozen_string_literal: true

# == Schema Information
#
# Table name: drives
#
#  id              :bigint           not null, primary key
#  name            :string
#  description     :text
#  start_time      :datetime
#  end_time        :datetime
#  created_by_id   :bigint
#  updated_by_id   :bigint
#  organization_id :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  duration        :integer
#
class DriveSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :start_time, :end_time, :created_by_id,
             :updated_by_id, :organization_id, :invitation_sent, :appeared, :total_submissions
  has_many :drives_problems

  def invitation_sent
    object.candidates.count
  end

  def appeared
    object.drives_candidates.where.not(start_time: nil).count
  end

  def total_submissions
    drives_candidates = DrivesCandidate.where(drive_id: object.id)
    count = 0
    drives_candidates.each do |drives_candidate|
      count += Submission.where(drives_candidate_id: drives_candidate.id).count
    end
    count
  end
end
