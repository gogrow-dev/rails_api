# frozen_string_literal: true

module Api
  module V1
    module Users
      class PasswordsController < DeviseTokenAuth::PasswordsController
        include Api::Concerns::ActAsApiRequest
        include Api::Concerns::Serializable

        def edit
          super do |_user|
            return render 'edit'
          end
        end

        def render_create_success
          render_serialized(@resource, status: :created)
        end

        def render_create_error(_)
          render_serialized(@resource, status: :unprocessable_entity)
        end

        def render_update_error_unauthorized
          return render(:edit) if http_request?

          render_generic_error('Unauthorized', status: :unauthorized)
        end

        def render_update_error_password_not_required
          return render(:edit) if http_request?

          msg = I18n.t('devise_token_auth.passwords.password_not_required', provider: @resource.provider.humanize)
          render_generic_error(msg, status: :unprocessable_entity)
        end

        def render_update_error_missing_password
          return render(:edit) if http_request?

          msg = I18n.t('devise_token_auth.passwords.missing_passwords')
          render_generic_error(msg, status: :unprocessable_entity)
        end

        def render_create_error_missing_email
          return render(:edit) if http_request?

          msg = I18n.t('devise_token_auth.passwords.missing_email')
          render_generic_error(msg, status: :unauthorized)
        end

        def render_update_success
          return render(:edit) if http_request?

          render_serialized(@resource, status: :ok)
        end

        def render_update_error
          return render(:edit) if http_request?

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

        private

        def http_request?
          request.format.nil? && request.headers['accept']&.include?('text/html')
        end
      end
    end
  end
end
