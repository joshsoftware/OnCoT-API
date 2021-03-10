# frozen_string_literal: true

class CreateDrivesProblems < ActiveRecord::Migration[5.2]
  def change
    create_table :drives_problems do |t|
      t.references :drive, foreign_key: true
      t.references :problem, foreign_key: true

      t.timestamps
    end
  end
end
