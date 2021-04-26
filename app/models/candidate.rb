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
class Candidate < ApplicationRecord
  has_many :drives_candidates
  has_many :drives, through: :drives_candidates
end
