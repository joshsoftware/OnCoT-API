# frozen_string_literal: true

# == Schema Information
#
# Table name: problems
#
#  id               :bigint           not null, primary key
#  title            :string
#  description      :text
#  created_by_id    :bigint
#  updated_by_id    :bigint
#  organization_id  :bigint           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  submission_count :integer
#
class Problem < ApplicationRecord
  belongs_to :updated_by, class_name: 'User', foreign_key: 'updated_by_id'
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'
  belongs_to :organization
  has_many :test_cases
  has_many :submissions
  has_many :drives_problems
  has_many :drives, through: :drives_problems
end
