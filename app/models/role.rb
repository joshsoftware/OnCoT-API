class Role < ApplicationRecord
  self.inheritance_column = nil
  has_many :users
end
