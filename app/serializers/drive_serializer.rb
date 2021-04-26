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
class DriveSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :start_time, :end_time, :created_by_id, :updated_by_id, :organization_id
  has_many :drives_problems
end
