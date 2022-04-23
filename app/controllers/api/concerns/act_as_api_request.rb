# frozen_string_literal: true

module Api
  module Concerns
    module ActAsApiRequest
      extend ActiveSupport::Concern

      included do
        extend DeviseTokenAuth::Concerns::SetUserByToken
        before_action :skip_session_storage
      end

      def skip_session_storage
        request.session_options[:skip] = true
      end
    end
  end
end
