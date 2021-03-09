# frozen_string_literal: true

class RemoveColumnsFromCandidate < ActiveRecord::Migration[5.2]
  def change
    remove_column :candidates, :invite_status
    remove_column :candidates, :is_qualified
    remove_column :candidates, :drive_id
  end
end
