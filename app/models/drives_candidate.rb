# frozen_string_literal: true

class DrivesCandidate < ApplicationRecord
  belongs_to :drive
  belongs_to :candidate

  def generate_token
    self.token = SecureRandom.hex(20)
    self.email_sent_at = Time.now.utc
  end
end
