# frozen_string_literal: true

module Api
  module Users
    class SessionsController < Devise::SessionsController
      def create
        super do |user|
          render json: UserSerializer.render(user), status: :created

          return
        end
      end

      private

      def respond_to_on_destroy
        current_user ? log_out_success : log_out_failure
      end

      def log_out_success
        render status: :no_content
      end

      def log_out_failure
        render json: { error: 'You need to sign in or sign up before continuing.' }, status: :unauthorized
      end
    end
  end
end
