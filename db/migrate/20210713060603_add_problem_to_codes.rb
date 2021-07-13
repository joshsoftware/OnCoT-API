# frozen_string_literal: true

class AddProblemToCodes < ActiveRecord::Migration[6.1]
  def change
    add_reference :codes, :problem, null: false, foreign_key: true
  end
end
