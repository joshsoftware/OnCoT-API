class AddDriveStartTimeToDrivesCandidate < ActiveRecord::Migration[6.1]
  def change
    add_column :drives_candidates, :drive_start_time, :datetime
    add_column :drives_candidates, :drive_end_time, :datetime
  end
end
