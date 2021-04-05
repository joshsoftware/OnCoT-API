# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    user_role = Role.find(user.role_id).name

    if user.present?
      if user_role == 'Admin'
        can :manage, :all
      else
        can :read, [Problem, TestCase, Drive, Rule]
      end
    else
      can :sign_in
    end
  end
end
