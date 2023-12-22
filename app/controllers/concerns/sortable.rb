# frozen_string_literal: true

# This module adds the ability to sort scopes using the #sort method.
# Example usage:
# class UsersController < ApplicationController
#   include Sortable
#
#   sortable_by :name, :created_at
#
#   def index
#     scope = sort(User.all)
#     render json: scope
#   end
# end
#
# Example requests:
# GET /users?sort_key=name
# GET /users?sort_key=name&sort_direction=asc_nulls_first
# GET /users?sort_key=created_at&sort_direction=asc
module Sortable
  extend ActiveSupport::Concern

  class_methods do
    attr_reader :sortable_keys

    # @param keys [Array<Symbol,String>]
    def sortable_by(*keys)
      @sortable_keys = keys
    end
  end

  # @param scope [ActiveRecord::Relation]
  # @return [ActiveRecord::Relation]
  def sort(scope)
    return scope unless sort_key && sort_direction

    validate_sort_key!

    Queries::Sort.call(scope, sort_key:, sort_direction:)
  end

  protected

  def sort_direction
    params[:sort_direction] || :desc
  end

  def sort_key
    params[:sort_key]
  end

  private

  def validate_sort_key!
    return if self.class.sortable_keys.include?(sort_key)

    raise ActionController::BadRequest, "Invalid sort key: #{sort_key}, must be one of #{self.class.sortable_keys}"
  end
end
