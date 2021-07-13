# frozen_string_literal: true

class RemoveDrivesProblemFromCodes < ActiveRecord::Migration[6.1]
  def change
    remove_reference :codes, :drives_problem, null: false, foreign_key: true
  end
end
