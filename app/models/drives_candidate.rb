# frozen_string_literal: true

class DrivesCandidate < ApplicationRecord
  belongs_to :drive
  belongs_to :candidate
  has_many :submissions
end
