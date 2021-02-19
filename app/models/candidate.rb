class Candidate < ApplicationRecord
	belongs_to :drive
	has_many :submissions
end
