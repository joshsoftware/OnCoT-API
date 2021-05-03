# frozen_string_literal: true

class AddOutputToTestCaseResult < ActiveRecord::Migration[6.1]
  def change
    add_column :test_case_results, :output, :string
  end
end
