# frozen_string_literal: true

class Drive < ApplicationRecord
  belongs_to :updated_by, class_name: 'User', foreign_key: 'updated_by_id'
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'
  belongs_to :organization
  has_many :drives_candidates
  has_many :drives_problems
  has_many :candidates, through: :drives_candidates
  has_many :problems, through: :drives_problems
  has_one :rule

  accepts_nested_attributes_for :drives_problems, allow_destroy: true
  def yet_to_start?
    start_time.localtime > DateTime.current.localtime
  end

  def ended?
    end_time.localtime < DateTime.current.localtime
  end

  def ongoing?
    if start_time.localtime < DateTime.current.localtime && DateTime.current.localtime < end_time.localtime
      true
    else
      false
    end
  end
end
