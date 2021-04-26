# frozen_string_literal: true

# == Schema Information
#
# Table name: candidates
#
#  id                  :bigint           not null, primary key
#  first_name          :string
#  last_name           :string
#  email               :string
#  is_profile_complete :boolean
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  mobile_number       :string
#
class CandidateSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :mobile_number
end
