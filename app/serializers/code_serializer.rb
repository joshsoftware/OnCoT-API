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
  attributes :id, :answer, :lang_code, :problem_id, :token, :submission_count_left

  def token
    object.drives_candidate.token
  end

  def submission_count_left
    submissions = Submission.where(drives_candidate_id: object.drives_candidate.id, problem_id: object.problem.id)
    total_count = object.problem.submission_count
    total_count - submissions.count
  end
end
