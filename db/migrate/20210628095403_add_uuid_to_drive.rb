# frozen_string_literal: true

class AddUuidToDrive < ActiveRecord::Migration[6.1]
  def change
    add_column :drives, :uuid, :string
  end
end
