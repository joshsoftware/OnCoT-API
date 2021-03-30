# frozen_string_literal: true

module AuthorizationHelper
  def auth_tokens_for_user(user)
    request.headers.merge! user.create_new_auth_token
  end
end
