# frozen_string_literal: true

class Snapshot < ApplicationRecord
  belongs_to :drives_candidate
end
