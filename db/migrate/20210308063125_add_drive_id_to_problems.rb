class AddDriveIdToProblems < ActiveRecord::Migration[5.2]
  def change
    add_column :problems, :drive_id, :integer
  end
end
