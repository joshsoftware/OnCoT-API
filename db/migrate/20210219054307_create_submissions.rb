# frozen_string_literal: true

class CreateSubmissions < ActiveRecord::Migration[5.2]
  def change
    create_table :submissions do |t|
      t.text :answer
      t.references :candidate, null: false, foreign_key: true
      t.references :problem, null: false, foreign_key: true
      t.timestamps
    end
  end
end
