class Drive < ApplicationRecord
  belongs_to :updated_by, class_name: 'User', foreign_key: 'updated_by_id'
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'
  belongs_to :organization
  has_many :drives_candidates
  has_many :candidates, through: :drives_candidates
  has_and_belongs_to_many :problems
  has_one :rule
end

