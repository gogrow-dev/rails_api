# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

gem 'rails', '~> 7.1', '>= 7.1.3'

gem 'aws-sdk-s3', '~> 1.122'
gem 'blueprinter', '~> 0.30.0'
gem 'bootsnap', require: false
gem 'devise', '~> 4.9', '>= 4.9.3'
gem 'devise-jwt', '~> 0.11.0'
gem 'pagy', '~> 6.1'
gem 'pg', '~> 1.5', '>= 1.5.4'
gem 'puma', '~> 6.4'
gem 'rack-cors', '~> 2.0', '>= 2.0.1'
gem 'redis', '~> 5.0', '>= 5.0.8'
gem 'ruby-vips', '~> 2.2'
gem 'sidekiq', '~> 7.1', '>= 7.1.6'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'bullet', '~> 7.1', '>= 7.1.6'
  gem 'debug', '~> 1.8', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails', '~> 2.8', '>= 2.8.1'
  gem 'factory_bot_rails', '~> 6.2'
  gem 'faker', '~> 3.2', '>= 3.2.1'
  gem 'rspec-rails', '~> 6.0', '>= 6.0.3'
  gem 'rubocop', '~> 1.57', '>= 1.57.1', require: false
  gem 'rubocop-rails', '~> 2.21', '>= 2.21.2', require: false
end

group :development do
  gem 'annotate', '~> 3.2'
  gem 'dockerfile-rails', '~> 1.5', '>= 1.5.12'
  gem 'letter_opener', '~> 1.8', '>= 1.8.1'
end

group :test do
  gem 'shoulda-matchers', '~> 5.3'
  gem 'simplecov', '~> 0.22.0', require: false
end
