# frozen_string_literal: true

require 'devise/jwt/test_helpers'

module AuthHelper
  def get_jwt(user)
    auth_headers = Devise::JWT::TestHelpers.auth_headers({}, user)
    auth_headers['Authorization']
  end
end
