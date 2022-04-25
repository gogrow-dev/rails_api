# frozen_string_literal: true

# Load the Rails application.
require_relative 'application'

Rails.application.configure do
  config.active_job.queue_adapter = :sidekiq
end

# Initialize the Rails application.
Rails.application.initialize!
