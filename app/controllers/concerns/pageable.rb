# frozen_string_literal: true

# Example usage:
#
# class UsersController < ApplicationController
#  include Pageable
#
#   def index
#     scope = paginate(User.all)
#     render json: scope
#   end
# end
#
# Example requests:
# GET /users?page=1&per_page=10
# GET /users?page=2&per_page=50
module Pageable
  # @param scope [ActiveRecord::Relation]
  # @param page [Integer,String,nil]
  # @param per_page [Integer,String,nil]
  # @return [ActiveRecord::Relation]
  def paginate(scope)
    Queries::Paginate.call(scope, page:, per_page:)
  end

  # @return [String,nil]
  def page
    params[:page]
  end

  # @return [String,nil]
  def per_page
    params[:per_page]
  end
end
