# frozen_string_literal: true

require File.expand_path("production.rb", __dir__)

Rails.application.configure do
  config.server_timing = ENV.fetch("SERVER_TIMING", nil).present?
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "debug")
end
