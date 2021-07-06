# frozen_string_literal: true

class Code < ApplicationRecord
  belongs_to :drives_candidate
  belongs_to :drives_problem
end
