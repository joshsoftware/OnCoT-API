# frozen_string_literal: true

class AddTimeInMinutesToProblems < ActiveRecord::Migration[6.1]
  def change
    add_column :problems, :time_in_minutes, :int, default: 60
  end
end
