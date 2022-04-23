# frozen_string_literal: true

module Helpers
  module Request
    def json_response
      JSON.parse(response.body).with_indifferent_access
    end

    def error_details
      json_response[:errors].flat_map { |error_hsh| error_hsh[:detail] }
    end

    def error_attributes
      json_response[:errors].map { |error_hsh| error_hsh[:source][:parameter].to_sym }
    end
  end
end
