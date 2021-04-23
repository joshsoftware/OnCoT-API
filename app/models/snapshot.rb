# frozen_string_literal: true

class Snapshot < ApplicationRecord
  belongs_to :drive
  belongs_to :candidate
end
