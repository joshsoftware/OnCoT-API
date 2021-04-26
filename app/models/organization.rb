# frozen_string_literal: true

# == Schema Information
#
# Table name: organizations
#
#  id             :bigint           not null, primary key
#  name           :string
#  description    :text
#  email          :string
#  contact_number :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Organization < ApplicationRecord
  has_many :problems
  has_many :drives
  has_many :users
end
