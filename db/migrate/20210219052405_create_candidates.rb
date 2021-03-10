# frozen_string_literal: true

class CreateCandidates < ActiveRecord::Migration[5.2]
  def change
    create_table :candidates do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.boolean :is_profile_complete
      t.string :invite_status
      t.boolean :is_qualified
      t.references :drive, null: false, foreign_key: true

      t.timestamps
    end
  end
end
