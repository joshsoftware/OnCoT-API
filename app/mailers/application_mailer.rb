# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.secrets.GMAIL_USER_NAME
  layout 'mailer'
end
