# frozen_string_literal: true

class AddUuidToDrivesCandidate < ActiveRecord::Migration[6.1]
  def change
    add_column :drives_candidates, :uuid, :string
  end
end
