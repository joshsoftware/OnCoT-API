# frozen_string_literal: true

# == Schema Information
#
# Table name: rules
#
#  id          :bigint           not null, primary key
#  type_name   :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  default     :boolean          default(FALSE)
#
class RuleSerializer < ActiveModel::Serializer
  attributes :type_name, :description, :drive_id
end
