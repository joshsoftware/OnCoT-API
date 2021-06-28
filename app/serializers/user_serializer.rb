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
class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :organization_id, :role_id, :mobile_number,
             :role, :invitation_accepted

  def role
    object.role.name
  end

  def invitation_accepted
    object.invitation_accepted_at?
  end
end
