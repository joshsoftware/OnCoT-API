class Candidate < ApplicationRecord
  belongs_to :organization
  belongs_to :role
  has_many :submissions
end
