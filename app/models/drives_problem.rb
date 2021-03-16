# frozen_string_literal: true

class DrivesProblem < ApplicationRecord
  belongs_to :drive
  belongs_to :problem
end
