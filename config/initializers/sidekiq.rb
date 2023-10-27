# frozen_string_literal: true

require 'sidekiq'
require 'sidekiq/web'

Sidekiq.configure_client do |config|
  config.redis = {
    url: ENV.fetch('SIDEKIQ_REDIS_URL', nil),
    ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
  }
end

Sidekiq.configure_server do |config|
  config.redis = {
    url: ENV.fetch('SIDEKIQ_REDIS_URL', nil),
    ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
  }
end

unless Rails.env.development? || Rails.env.test?
  sidekiq_password = ENV.fetch('SIDEKIQ_PASSWORD', SecureRandom.hex(12))

  Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
    Rack::Utils.secure_compare(Digest::SHA256.hexdigest(user), Digest::SHA256.hexdigest('admin')) &
      Rack::Utils.secure_compare(Digest::SHA256.hexdigest(password), Digest::SHA256.hexdigest(sidekiq_password))
  end
end
