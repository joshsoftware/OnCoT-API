# frozen_string_literal: true

# == Schema Information
#
# Table name: drives_problems
#
#  id         :bigint           not null, primary key
#  drive_id   :bigint
#  problem_id :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class DrivesProblemSerializer < ActiveModel::Serializer
  attributes :id, :problem_id, :drive_id
end
