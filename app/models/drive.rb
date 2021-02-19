class Drive < ApplicationRecord
  belongs_to :user
  belongs_to :organization
  has_many :candidates
end
