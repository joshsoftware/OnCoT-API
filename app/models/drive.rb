class Drive < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :organization
  has_many :candidates
end
