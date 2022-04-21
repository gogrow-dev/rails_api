# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Api::Concerns::ActAsApiRequest
end
