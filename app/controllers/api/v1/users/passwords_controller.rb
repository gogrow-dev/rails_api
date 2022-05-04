# frozen_string_literal: true

module Api
  module V1
    module Users
      class PasswordsController < DeviseTokenAuth::PasswordsController
        include Api::Concerns::ActAsApiRequest
        include Api::Concerns::Serializable

        def render_create_success
          render_serialized(@resource, status: :created)
        end

        def render_create_error(_)
          render_serialized(@resource, status: :unprocessable_entity)
        end

        def render_update_error_unauthorized
          render_generic_error('Unauthorized', status: :unauthorized)
        end

        def render_update_error_password_not_required
          msg = I18n.t('devise_token_auth.passwords.password_not_required', provider: @resource.provider.humanize)
          render_generic_error(msg, status: :unprocessable_entity)
        end

        def render_update_error_missing_password
          msg = I18n.t('devise_token_auth.passwords.missing_passwords')
          render_generic_error(msg, status: :unprocessable_entity)
        end

        def render_create_error_missing_email
          msg = I18n.t('devise_token_auth.passwords.missing_email')
          render_generic_error(msg, status: :unauthorized)
        end

        def render_update_success
          render_serialized(@resource, status: :ok)
        end

        def render_update_error
          render_serialized(@resource, status: :unprocessable_entity)
        end

        def render_not_found_error
          msg = if Devise.paranoid
                  I18n.t('devise_token_auth.passwords.sended_paranoid')
                else
                  I18n.t('devise_token_auth.passwords.user_not_found', email: @email)
                end
          render_generic_error(msg, status: :not_found)
        end
      end
    end
  end
end
