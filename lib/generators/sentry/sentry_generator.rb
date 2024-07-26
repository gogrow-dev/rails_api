# frozen_string_literal: true

class SentryGenerator < Rails::Generators::Base
  source_root File.expand_path('templates', __dir__)

  def add_sentry_gem
    gem 'stackprof'
    gem 'sentry-ruby'
    gem 'sentry-rails'
    run 'bundle'
  end

  def create_sentry_initializer
    template 'sentry.rb', 'config/initializers/sentry.rb'
  end

  def create_sentry_environment_variables
    append_to_file '.env.sample', "SENTRY_DSN=sentry_dsn\n"
  end
end
