# frozen_string_literal: true

class AddSubmissionCountToProblems < ActiveRecord::Migration[5.2]
  def change
    add_column :problems, :submission_count, :integer
  end
end
