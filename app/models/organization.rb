class Organization < ApplicationRecord
  has_many :drives
	has_many :users
	has_many :problems
end
