# frozen_string_literal: true

module Api
  module Users
    class PasswordsController < Devise::PasswordsController
      include FakeSession
      respond_to :json
    end
  end
end
