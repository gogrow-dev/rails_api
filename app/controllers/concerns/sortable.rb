# frozen_string_literal: true

# This module adds the ability to sort scopes using the #sort method.
# Example usage:
# class UsersController < ApplicationController
#   include Sortable
#
#   sortable_by :name, :created_at, email: :login
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
# GET /users?sort_key=login&sort_direction=asc_nulls_last
module Sortable
  extend ActiveSupport::Concern

  included do
    class_attribute :sort_fields, default: []
    class_attribute :mapped_sort_fields, default: {}
  end

  class_methods do
    # @param keys [Array<Symbol,String>]
    # @param mapped_keys [Hash<Symbol,String>]
    def sortable_by(*keys, **mapped_keys)
      self.sort_fields = keys.map(&:to_s)
      self.mapped_sort_fields = mapped_keys.with_indifferent_access
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
    self.class.mapped_sort_fields.key(params[:sort_key]).presence || params[:sort_key]
  end

  private

  def validate_sort_key!
    return if self.class.sort_fields.include?(sort_key) || self.class.mapped_sort_fields[sort_key].present?

    raise ActionController::BadRequest, "Invalid sort key: #{sort_key}, must be one of #{self.class.sort_fields + self.class.mapped_sort_fields.values}"
  end
end
