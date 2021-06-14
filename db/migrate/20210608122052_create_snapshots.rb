# frozen_string_literal: true

class CreateSnapshots < ActiveRecord::Migration[6.1]
  def change
    create_table :snapshots do |t|
      t.string :image_url
      t.belongs_to :drives_candidate

      t.timestamps
    end
  end
end
