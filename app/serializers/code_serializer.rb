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
class CodeSerializer < ActiveModel::Serializer
  attributes :id, :answer, :lang_code, :problem_id, :token

  def token
    object.drives_candidate.token
  end
  def problem_id
    object.drives_problem.problem.id
  end
end
