# frozen_string_literal: true

# == Schema Information
#
# Table name: rules
#
#  id          :bigint           not null, primary key
#  type_name   :string
#  description :text
#  drive_id    :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Rule < ApplicationRecord
  belongs_to :drive, optional: true
end
