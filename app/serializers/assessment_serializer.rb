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
class AssessmentSerializer < ActiveModel::Serializer
  attributes :uuid, :name
end
