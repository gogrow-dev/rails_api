# frozen_string_literal: true

module Api
  module V1
    module Users
      class RegistrationsController < DeviseTokenAuth::RegistrationsController
        include Api::Concerns::ActAsApiRequest
        include Api::Concerns::Serializable

        def sign_up_params
          params.require(:user).permit(:email, :password, :password_confirmation)
        end

        def account_update_params
          params.require(:user).permit(:email, :password, :password_confirmation, :current_password)
        end

        def render_create_success
          render_serialized(@resource, status: :created)
        end

        def render_create_error
          render_serialized(@resource, status: :unprocessable_entity)
        end

        def render_update_success
          render_serialized(@resource, status: :created)
        end

        def render_update_error
          render_serialized(@resource, status: :unprocessable_entity)
        end
      end
    end
  end
end
