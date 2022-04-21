# frozen_string_literal: true

module Api
  module Concerns
    module ActAsApiRequest
      extend ActiveSupport::Concern

      included do
        extend DeviseTokenAuth::Concerns::SetUserByToken
        skip_before_action :verify_authenticity_token
        before_action :skip_session_storage
      end

      def skip_session_storage
        request.session_options[:skip] = true
      end
    end
  end
end
