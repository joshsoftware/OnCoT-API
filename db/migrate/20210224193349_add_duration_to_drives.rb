# frozen_string_literal: true

class AddDurationToDrives < ActiveRecord::Migration[5.2]
  def change
    add_column :drives, :duration, :integer
  end
end
