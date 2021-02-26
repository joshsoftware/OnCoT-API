class User < ApplicationRecord
  belongs_to :organization
  belongs_to :role
  has_many :problems
  has_many :drives
  has_many :test_cases
end

