class DrivesCandidate < ApplicationRecord
  belongs_to :drive
  belongs_to :candidate

  def generate_token!
    self.token = generate_token
    self.email_sent_at = Time.now.utc
    save!
  end
  
  private
  
  def generate_token
    SecureRandom.hex(20)
  end
end

  def token_valid?
    drive=DrivesCandidate.find_by(id:self.id)
    (drive.end_time) > Time.now.utc
  end
end
