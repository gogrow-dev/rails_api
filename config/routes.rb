# frozen_string_literal: true

Rails.application.routes.draw do
  get '/healthcheck', to: ->(_env) { [200, {}, ['OK']] }

  defaults format: :html do
    mount Sidekiq::Web => '/sidekiq'

    # Uncomment when using AdminUser devise model for authenticated admin panels
    # devise_for :admin_users, only: %i[sessions password], controllers: {
    #   sessions: 'admin_users/sessions',
    #   passwords: 'admin_users/passwords'
    # }
    # root to: '/admin'
  end

  devise_for :users, path: 'api/v1/users', defaults: { format: :json }, controllers: {
    confirmations: 'api/v1/users/confirmations',
    sessions: 'api/v1/users/sessions',
    registrations: 'api/v1/users/registrations',
    passwords: 'api/v1/users/passwords'
  }

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      # Your api routes go here
    end
  end
end
