class TestCase < ApplicationRecord
  belongs_to :problem
  belongs_to :user
  has_one :result
end
