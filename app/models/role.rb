# frozen_string_literal: true

class Role < ApplicationRecord
  has_many :users
  scope :reviewer, -> { where(name: 'reviewer') }
end
