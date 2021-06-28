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
#
class Drive < ApplicationRecord
  belongs_to :updated_by, class_name: 'User', foreign_key: 'updated_by_id'
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'
  belongs_to :organization
  has_many :drives_candidates
  has_many :drives_problems
  has_many :candidates, through: :drives_candidates
  has_many :problems, through: :drives_problems
  has_many :rules

  after_create :assign_rules
  after_save :update_drives_candidates, if: ->  {saved_change_to_start_time? || saved_change_to_end_time?}
  before_create :assign_uuid

  accepts_nested_attributes_for :drives_problems, allow_destroy: true
  def yet_to_start?
    start_time.localtime > DateTime.current.localtime
  end

  def update_drives_candidates
    self.drives_candidates.each do |drives_candidate|
        drives_candidate.update(drive_start_time: start_time, drive_end_time: end_time)
    end
  end

  def assign_rules
    Rule.where(type_name: 'default').each do |rule|
      r = rule.dup
      r.drive_id = id
      r.type_name = nil
      r.save
    end
  end

  def assign_uuid
    self.uuid = SecureRandom.hex
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
