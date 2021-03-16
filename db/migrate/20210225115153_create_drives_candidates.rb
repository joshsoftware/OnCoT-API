# frozen_string_literal: true

class CreateDrivesCandidates < ActiveRecord::Migration[5.2]
  def change
    create_table :drives_candidates do |t|
      t.belongs_to :drive
      t.belongs_to :candidate
      t.string :token
      t.datetime :email_sent_at
      t.datetime :start_time
      t.datetime :end_time
      t.string :invite_status
      t.boolean :is_qualified
      t.timestamps
    end
  end
end
