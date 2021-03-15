# frozen_string_literal: true

class Drive < ApplicationRecord
  belongs_to :updated_by, class_name: 'User', foreign_key: 'updated_by_id'
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'
  belongs_to :organization
  has_many :drives_candidates
  has_many :candidates, through: :drives_candidates
  has_and_belongs_to_many :problems
  has_one :rule

  def yet_to_start?
    return true if start_date > Time.current
  end

  def ended?
    return true if end_date < Time.current
  end

  def ongoing?
    return true if start_date < Time.current && Time.current < end_date
  end
end
