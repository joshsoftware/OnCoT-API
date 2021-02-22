class TestCaseResult < ApplicationRecord
  belongs_to :submission
  belongs_to :testcase
end
