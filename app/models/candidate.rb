class Candidate < ApplicationRecord
  has_many :submissions
  has_many :drives_candidates
  has_many :drives, through: :drives_candidates
end
