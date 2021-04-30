# frozen_string_literal: true

class RemoveDriveIdAndAddDefaultToRules < ActiveRecord::Migration[6.1]
  def change
    remove_column :rules, :drive_id, :integer
    add_column :rules, :default, :boolean, default: false
    add_column :drives, :rule_id, :integer, foreign_key: true
  end
end
