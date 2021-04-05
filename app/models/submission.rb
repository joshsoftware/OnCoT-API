# frozen_string_literal: true

class Submission < ApplicationRecord
  belongs_to :drives_candidate
  belongs_to :problem
  has_many :test_case_results
end
