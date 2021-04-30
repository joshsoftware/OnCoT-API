# frozen_string_literal: true

# == Schema Information
#
# Table name: drives
#
#  id              :bigint           not null, primary key
#  name            :string
#  description     :text
#  start_time      :datetime
#  end_time        :datetime
#  created_by_id   :bigint
#  updated_by_id   :bigint
#  organization_id :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  duration        :integer
#  rule_id         :integer
#
class Drive < ApplicationRecord
  belongs_to :updated_by, class_name: 'User', foreign_key: 'updated_by_id'
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'
  belongs_to :organization
  belongs_to :rule
  has_many :drives_candidates
  has_many :drives_problems
  has_many :candidates, through: :drives_candidates
  has_many :problems, through: :drives_problems
  has_many :rules

  accepts_nested_attributes_for :drives_problems, allow_destroy: true
  before_create :set_rule

  def set_rule
    rule = Rule.find(default: true).first
    rule_id = rule.id if rule
  end

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
