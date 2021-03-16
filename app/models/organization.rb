# frozen_string_literal: true

class Organization < ApplicationRecord
  has_many :problems
  has_many :drives
  has_many :users
end
