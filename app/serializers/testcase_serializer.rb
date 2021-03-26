# frozen_string_literal: true

class TestcaseSerializer < ActiveModel::Serializer
  attributes :id, :input, :output, :marks, :problem_id, :created_by_id, :updated_by_id
end
