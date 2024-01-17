# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: 'api', defaults: { format: :json } do
    devise_for :users, controllers: {
      confirmations: 'api/users/confirmations',
      sessions: 'api/users/sessions',
      registrations: 'api/users/registrations',
      passwords: 'api/users/passwords'
    }
  end

  get '/healthcheck', to: ->(_env) { [200, {}, ['OK']] }

  defaults format: :html do
    mount Sidekiq::Web => '/sidekiq'

    # Uncomment for admin panel
    # devise_for :admin_users, only: %i[sessions password], controllers: {
    #   sessions: 'admin_users/sessions',
    #   passwords: 'admin_users/passwords'
    # }
    # root to: '/admin'
  end
end
