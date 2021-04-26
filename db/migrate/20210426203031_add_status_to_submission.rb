# frozen_string_literal: true

class AddStatusToSubmission < ActiveRecord::Migration[6.1]
  def change
    add_column :submissions, :status, :string, default: 'processing'
  end
end
