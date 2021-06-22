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
class DrivesCandidate < ApplicationRecord
  belongs_to :drive
  belongs_to :candidate
  has_many :submissions
  has_many :snapshots

  def generate_token
    self.token = SecureRandom.hex(20)
    self.email_sent_at = Time.now.utc
  end
end
