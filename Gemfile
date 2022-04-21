# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.1'

gem 'bootsnap', require: false
gem 'devise', '~> 4.8', '>= 4.8.1'
gem 'devise_token_auth', '~> 1.2', github: 'lynndylanhurley/devise_token_auth',
                                   ref: '5b1a5e19450f3755ce5ebe2f631b40c876ffc22d'
gem 'jsonapi-serializer', '~> 2.2'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rack-cors', '~> 1.1', '>= 1.1.1'
gem 'rails', '~> 7.0.2', '>= 7.0.2.3'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'factory_bot_rails', '~> 6.2'
  gem 'faker', '~> 2.20'
  gem 'pry-byebug', '~> 3.9'
  gem 'rspec-rails', '~> 5.1', '>= 5.1.1'
end

group :development do
  gem 'rubocop-rails', '~> 2.14', '>= 2.14.2', require: false
  gem 'rubocop-rspec', '~> 2.10', require: false
  gem 'shoulda-matchers', '~> 5.0'
  gem 'spring', '~> 4.0'
end
