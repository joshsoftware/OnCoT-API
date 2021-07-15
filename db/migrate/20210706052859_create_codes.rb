# frozen_string_literal: true

class CreateCodes < ActiveRecord::Migration[6.1]
  def change
    create_table :codes do |t|
      t.text :answer
      t.integer :lang_code
      t.references :drives_candidate, null: false, foreign_key: true
      t.references :problem, null: false, foreign_key: true
      t.timestamps
    end
  end
end
