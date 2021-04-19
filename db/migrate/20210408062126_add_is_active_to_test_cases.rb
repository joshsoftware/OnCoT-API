# frozen_string_literal: true

class AddIsActiveToTestCases < ActiveRecord::Migration[6.1]
  def change
    add_column :test_cases, :is_active, :boolean
  end
end
