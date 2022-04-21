# frozen_string_literal: true

module Helpers
  module Authentication
    def auth_headers(resource = nil)
      resource ||= user
      resource.create_new_auth_token
    end
  end
end
