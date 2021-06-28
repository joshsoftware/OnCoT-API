# frozen_string_literal: true

class AddIsActiveToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :is_active, :boolean
    add_column :users, :invitation_sent_by, :integer
  end
end
