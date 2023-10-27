# frozen_string_literal: true

module Api
  module Users
    class ConfirmationsController < Devise::ConfirmationsController
      respond_to :json
    end
  end
end
