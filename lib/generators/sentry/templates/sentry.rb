# frozen_string_literal: true

if Object.const_defined?(:Sentry)
  Sentry.init do |config|
    config.enabled_environments = %w[production staging]

    config.dsn = ENV.fetch('SENTRY_DSN', nil)

    config.environment = Rails.env

    kamal_release_sha = ENV.fetch('KAMAL_VERSION', nil)

    config.release = kamal_release_sha if kamal_release_sha.present?

    config.breadcrumbs_logger = %i[active_support_logger http_logger]

    config.traces_sample_rate = Rails.env.production? ? 0.5 : 1.0
  end
end
