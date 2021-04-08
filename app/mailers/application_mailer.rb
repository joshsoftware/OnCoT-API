# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: Figaro.env.MAIL_USERNAME
  layout 'mailer'
end
