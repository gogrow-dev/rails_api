# frozen_string_literal: true

module Api
  module V1
    module Users
      class SessionsController < DeviseTokenAuth::SessionsController
        include Api::Concerns::ActAsApiRequest
        include Api::Concerns::Serializable

        def resource_params
          params.require(:user).permit(:email, :password)
        end

        def render_create_success
          render_serialized(@resource, status: :created)
        end

        def render_create_error_not_confirmed
          msg = I18n.t('devise_token_auth.sessions.not_confirmed', email: @resource.email)
          render_generic_error(msg,
                               status: :unauthorized)
        end

        def render_create_error_account_locked
          msg = I18n.t('devise_token_auth.sessions.account_lock_msg')
          render_generic_error(msg, status: :unauthorized)
        end

        def render_create_error_bad_credentials
          msg = I18n.t('devise_token_auth.sessions.bad_credentials')
          render_generic_error(msg, status: :unauthorized)
        end

        def render_destroy_success
          render json: nil, status: :ok
        end

        def render_destroy_error
          msg = I18n.t('devise_token_auth.sessions.user_not_found')
          render_generic_error(msg, status: :not_found)
        end
      end
    end
  end
end
