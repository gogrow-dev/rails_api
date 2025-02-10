# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby file: ".ruby-version"

gem "rails", "~> 8.0.1"

gem "aws-sdk-s3", "~> 1.122"
gem "blueprinter", "~> 1.0", ">= 1.0.2"
gem "bootsnap", "~> 1.18", ">= 1.18.3", require: false
gem "devise", "~> 4.9", ">= 4.9.4"
gem "devise-jwt", "~> 0.11.0"
gem "dry-initializer", "~> 3.1", ">= 3.1.1"
gem "pg", "~> 1.5", ">= 1.5.6"
gem "puma", "~> 6.4", ">= 6.4.2"
gem "rack-cors", "~> 2.0", ">= 2.0.2"
gem "redis", "~> 5.2"
gem "ruby-vips", "~> 2.2", ">= 2.2.1"
gem "sidekiq", "~> 7.3"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
gem "warped", "~> 1.0.1"

group :development, :test do
  gem "bullet", "~> 8.0"
  gem "debug", "~> 1.9", ">= 1.9.2", platforms: %i[mri mingw x64_mingw]
  gem "dotenv-rails", "~> 3.1", ">= 3.1.2"
  gem "factory_bot_rails", "~> 6.4", ">= 6.4.3"
  gem "faker", "~> 3.2", ">= 3.2.3"
  gem "rspec-rails", "~> 6.1", ">= 6.1.3"
end

group :development do
  gem "annotaterb", "~> 4.13"
  gem "dockerfile-rails", "~> 1.6", ">= 1.6.17"
  gem "letter_opener", "~> 1.10"
  gem "rubocop-rails-omakase", require: false
end

group :test do
  gem "shoulda-matchers", "~> 6.2"
  gem "simplecov", "~> 0.22.0", require: false
end
