# frozen_string_literal: true

class AddCompletedAtToDrivesCandidate < ActiveRecord::Migration[6.1]
  def change
    add_column :drives_candidates, :completed_at, :datetime
    add_column :drives_candidates, :score, :integer 
  end
end
