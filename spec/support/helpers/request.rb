# frozen_string_literal: true

module Helpers
  module Request
    def json_response
      JSON.parse(response.body).with_indifferent_access
    end
  end
end
