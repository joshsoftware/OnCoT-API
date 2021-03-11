# frozen_string_literal: true

class RemoveDriveIdFromProblems < ActiveRecord::Migration[5.2]
  def change
    remove_column :problems, :drive_id
  end
end
