# frozen_string_literal: true

module Api
  module V1
    module Users
      class SessionsController < DeviseTokenAuth::SessionsController
        include Api::Concerns::ActAsApiRequest

        def resource_params
          params.require(:user).permit(:email, :password)
        end
      end
    end
  end
end
