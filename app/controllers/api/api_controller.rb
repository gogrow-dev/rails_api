# frozen_string_literal: true

module Api
  class ApiController < ActionController::API
    before_action :verify_authenticity_token
    include Api::Concerns::ActAsApiRequest
    include Api::Concerns::Serializable

    def route_not_found
      render_generic_error('Route not found', status: :not_found)
    end

    def verify_authenticity_token; end
  end
end
