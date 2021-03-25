# frozen_string_literal: true

class User < ApplicationRecord
  include DeviseTokenAuth::Concerns::User

  # Include default devise modules.
  devise :database_authenticatable
  before_save -> { skip_confirmation! }

  belongs_to :organization
  belongs_to :role
  has_many :problems
  has_many :drives
  has_many :test_cases
end
