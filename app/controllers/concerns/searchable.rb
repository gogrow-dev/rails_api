# frozen_string_literal: true

# Example usage:
#
# class User < ApplicationRecord
#  scope :search, ->(term) { where('name ILIKE ?', "%#{term}%") }
# end
#
# class UsersController < ApplicationController
#   include Searchable
#
#   def index
#     scope = search(User.all)
#     render json: scope
#   end
# end
#
# Example requests:
# GET /users?q=foo
# GET /users?q=foo%20bar
module Searchable
  # @param scope [ActiveRecord::Relation]
  # @param model_search_scope [Symbol]
  def search(scope, model_search_scope: :search)
    Queries::Search.call(scope, search_term:, model_search_scope:)
  end

  # @return [String]
  def search_term
    params[search_param]&.strip
  end

  def search_param
    :q
  end
end
