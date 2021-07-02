class AddApplicationIdToDrivesCandidates < ActiveRecord::Migration[6.1]
  def change
    add_column :drives_candidates, :application_id, :string
  end
end
