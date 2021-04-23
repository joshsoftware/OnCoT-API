# frozen_string_literal: true

class CreateSnapshots < ActiveRecord::Migration[6.1]
  def change
    create_table :snapshots do |t|
      t.string :url
      t.belongs_to :drive
      t.belongs_to :candidate

      t.timestamps
    end
  end
end
