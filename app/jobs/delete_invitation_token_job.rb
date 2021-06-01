# frozen_string_literal: true

class DeleteInvitationTokenJob < ApplicationJob
  def perform(user)
    user.update(invitation_token: nil)
  end
end
