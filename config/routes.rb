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

  mount Sidekiq::Web => '/sidekiq'
end
