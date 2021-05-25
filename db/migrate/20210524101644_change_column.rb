# frozen_string_literal: true

class ChangeColumn < ActiveRecord::Migration[6.1]
  def change
    change_column :rules, :drive_id, :bigint, null: true
  end
end
