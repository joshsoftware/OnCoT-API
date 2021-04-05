# frozen_string_literal: true

class RuleSerializer < ActiveModel::Serializer
  attributes :type_name, :description, :drive_id
end
