# frozen_string_literal: true

class AddAllowPasswordChangeToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :allow_password_change, :boolean, default: false, null: false
  end
end
