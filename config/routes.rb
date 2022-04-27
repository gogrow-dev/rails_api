# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  mount_devise_token_auth_for 'User', at: 'api/v1/users', controllers: {
    sessions: 'api/v1/users/sessions',
    registrations: 'api/v1/users/registrations',
    passwords: 'api/v1/users/passwords'
  }

  if Rails.env.development?
    mount Sidekiq::Web => '/sidekiq'
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end

  namespace :api do
    namespace :v1 do
      match '*unmatched', to: '/api/api#route_not_found', via: :all
    end
  end
end
