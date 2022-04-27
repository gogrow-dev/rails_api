# frozen_string_literal: true

module Api
  module Concerns
    module ActAsApiRequest
      extend ActiveSupport::Concern

      included do
        extend DeviseTokenAuth::Concerns::SetUserByToken
        skip_before_action :verify_authenticity_token
        before_action :skip_session_storage

        rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
        rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
        rescue_from ActionController::ParameterMissing, with: :render_parameter_missing
        rescue_from ActionController::RoutingError, with: :render_not_found
      end

      def skip_session_storage
        request.session_options[:skip] = true
      end

      def render_not_found(error)
        render_generic_error(error.message, status: :not_found)
      end

      def render_unprocessable_entity(error)
        render_generic_error(error.message, status: :unprocessable_entity)
      end

      def render_parameter_missing(error)
        render_generic_error(error.message, status: :unprocessable_entity)
      end
    end
  end
end
