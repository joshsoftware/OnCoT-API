class Problem < ApplicationRecord
  belongs_to :user
  belongs_to :organization
  has_many :test_cases
  has_many :submissions
end
