class DrivesCandidate < ApplicationRecord
  belongs_to :drive
  belongs_to :candidate

  def token_valid?
    drive=DrivesCandidate.find_by(id:self.id)
    (drive.end_time) > Time.now.utc
  end
end
