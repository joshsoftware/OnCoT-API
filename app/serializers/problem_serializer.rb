# frozen_string_literal: true

# == Schema Information
#
# Table name: problems
#
#  id               :bigint           not null, primary key
#  title            :string
#  description      :text
#  created_by_id    :bigint
#  updated_by_id    :bigint
#  organization_id  :bigint           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  submission_count :integer
#
class ProblemSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :created_at, :updated_at, :created_by_id, :updated_by_id,
             :organization_id, :submission_count

  has_many :drives_problems
end
