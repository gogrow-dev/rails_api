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
        # Devise stores the cookie by default, so in api requests, it is disabled
        # http://stackoverflow.com/a/12205114/2394842
        request.session_options[:skip] = true
      end
    end
  end
end
