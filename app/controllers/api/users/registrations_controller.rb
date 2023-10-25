# frozen_string_literal: true

module Api
  module Users
    class RegistrationsController < Devise::RegistrationsController
      include FakeSession

      respond_to :json

      def respond_with(resource, _opts = {})
        if resource.persisted?
          render json: UserSerializer.render(resource), status: :created
        else
          render json: resource.errors, status: :unprocessable_entity
        end
      end
    end
  end
end
