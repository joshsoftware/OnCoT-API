# frozen_string_literal: true

class AddAnswerIdToDrivesCandidate < ActiveRecord::Migration[6.1]
  def change
    add_column :drives_candidates, :answer_id, :integer
  end
end
