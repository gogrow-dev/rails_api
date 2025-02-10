# frozen_string_literal: true

# Taken from https://github.com/rails/rails/pull/52789.
# Once the app is updated to Rails 8, this file can be removed.
#
#
# Allows you to silence requests made to a specific path.
# This is useful for preventing recurring requests like healthchecks from clogging the logging.
# This middleware is used to do just that against the path /up in production by default.
#
# Example:
#
#   config.middleware.insert_before \
#     Rails::Rack::Logger, Rails::Rack::SilenceRequest, path: "/up"
#
class SilenceRequest
  def initialize(app, path:)
    @app = app
    @path = path
  end

  def call(env)
    if env["PATH_INFO"] == @path
      Rails.logger.silence { @app.call(env) }
    else
      @app.call(env)
    end
  end
end
