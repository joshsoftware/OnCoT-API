class Organization < ApplicationRecord
	has_many :users
	has_many :problems
	has_many :drives
end
