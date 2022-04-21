# frozen_string_literal: true

module Api
  class ApiController < ActionController::API
    include Api::Concerns::ActAsApiRequest
    include Api::Concerns::Serializable
  end
end
