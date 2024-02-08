# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  include Components

  default from: ENV.fetch('MAILER_SENDER', 'info@rails-api.com')
  layout 'mailer'
end
