# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  first_name             :string
#  last_name              :string
#  organization_id        :bigint           not null
#  role_id                :bigint           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  provider               :string           default("email"), not null
#  uid                    :string           default(""), not null
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  tokens                 :json
#
class User < ApplicationRecord
  include DeviseTokenAuth::Concerns::User

  # Include default devise modules.
  devise :database_authenticatable
  before_save -> { skip_confirmation! }
  before_create :default_values

  belongs_to :organization
  belongs_to :role
  has_many :problems
  has_many :drives
  has_many :test_cases

  def default_values
    self.is_active ||= true
  end
end
