# frozen_string_literal: true

class CreateTestCaseResults < ActiveRecord::Migration[5.2]
  def change
    create_table :test_case_results do |t|
      t.boolean :is_passed
      t.references :submission, null: false, foreign_key: true
      t.references :test_case, null: false, foreign_key: true

      t.timestamps
    end
  end
end
