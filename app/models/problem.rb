# frozen_string_literal: true

class Problem < ApplicationRecord
  belongs_to :updated_by, class_name: 'User', foreign_key: 'updated_by_id'
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'
  belongs_to :organization
  has_many :test_cases
  has_many :submissions
  has_and_belongs_to_many :drives, class_name: 'Drive'

  scope :get_problem, ->(id) { find(id) }
end
