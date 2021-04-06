# frozen_string_literal: true

class DrivesCandidate < ApplicationRecord
  belongs_to :drive
  belongs_to :candidate

  def generate_token!
    self.token = generate_token
    self.email_sent_at = Time.now.utc
    begin
      save!
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique => e
      drives_candidate = exists?
      raise e if drives_candidate.nil?
    end
  end

  private

  def generate_token
    SecureRandom.hex(20)
  end
end
