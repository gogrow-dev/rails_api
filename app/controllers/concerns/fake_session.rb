# frozen_string_literal: true

# This module is used to avoid the following error:
# "NoMethodError: undefined method `[]' for nil:NilClass"
# when using Devise with an API-only Rails app.
# This concern must be used in the controller that inherits from
# Devise::RegistrationsController when using Devise JWT.
module FakeSession
  extend ActiveSupport::Concern

  class FakeRackSession < Hash
    def enabled?
      false
    end
  end

  included do
    before_action :set_fake_rack_session_for_devise

    private

    def set_fake_rack_session_for_devise
      request.env["rack.session"] ||= FakeRackSession.new
    end
  end
end
