# frozen_string_literal: true

class Candidate < ApplicationRecord
  has_many :drives_candidates
  has_many :drives, through: :drives_candidates
  has_many :submissions
end
