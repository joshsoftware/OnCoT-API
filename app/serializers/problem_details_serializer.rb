# frozen_string_literal: true

class ProblemDetailsSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :time_in_minutes, :submission_count, :test_case

  def test_case
    object.test_cases.first.input
  end
end
