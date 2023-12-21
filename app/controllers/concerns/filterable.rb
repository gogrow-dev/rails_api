# frozen_string_literal: true

# Example usage:
#
# class UsersController < ApplicationController
#  include Filterable
#
#  filterable_by :name, :email, :age, 'posts.created_at'
#
#  def index
#   users = User.left_joins(:posts)
#   users = filter(users)
#   render json: users
#  end
# end
#
# Example requests:
# GET /users?name=John
# GET /users?name=John&name.rel=!=
# GET /users?name[]=John&name[]=Pedro&name.rel=in
# GET /users?age=18&age.rel=>
# GET /users?age[]=18&age[]=21&age.rel=between
# GET /users?posts.created_at[]=2020-01-01&posts.rel=>=
module Filterable
  extend ActiveSupport::Concern

  class_methods do
    # @param filter_keys [Array<Symbol,String>]
    def filterable_by(*filter_keys)
      @filter_fields = filter_keys
    end

    def filter_fields
      @filter_fields.presence || []
    end
  end

  # @param scope [ActiveRecord::Relation]
  # @param filter_conditions [Array<Hash>]
  # @param filter_conditions[:field] [Symbol,String]
  # @param filter_conditions[:value] [String,Integer,Array<String,Integer>]
  # @param filter_conditions[:relation] [String]
  # @return [ActiveRecord::Relation]
  def filter(scope, filter_conditions: filter_conditions(*filter_fields))
    Queries::Filter.call(scope, filter_conditions:)
  end

  # @param fields [Array<Symbol,String>]
  # @return [Array<Hash>]
  def filter_conditions(*fields)
    filter_fields = fields.presence || self.class.filter_fields

    filter_fields.filter_map do |field|
      next if params[field].blank?

      {
        field:,
        value: params[field],
        relation: params["#{field}.rel"] || (params[field].is_a?(Array) ? 'in' : '=')
      }
    end
  end
end
