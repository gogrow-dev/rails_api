# frozen_string_literal: true

module Api
  module V1
    module Users
      class RegistrationsController < DeviseTokenAuth::RegistrationsController
        include Api::Concerns::ActAsApiRequest

        def sign_up_params
          params.require(:user).permit(:email, :password, :password_confirmation)
        end

        def account_update_params
          params.require(:user).permit(:email, :password, :password_confirmation, :current_password)
        end
      end
    end
  end
end
