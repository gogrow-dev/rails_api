# frozen_string_literal: true

module Api
  module V1
    module Users
      class PasswordsController < DeviseTokenAuth::PasswordsController
        include Api::Concerns::ActAsApiRequest
      end
    end
  end
end
