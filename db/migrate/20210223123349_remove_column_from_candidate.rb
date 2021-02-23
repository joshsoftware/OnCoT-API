class RemoveColumnFromCandidate < ActiveRecord::Migration[5.2]
  def change
    remove_column :candidates, :drive_id
  end
end
