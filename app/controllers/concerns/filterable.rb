# frozen_string_literal: true

# Example usage:
#
# class UsersController < ApplicationController
#  include Filterable
#
#  filterable_by :name, :email, :age, 'posts.created_at', 'posts.id' => 'post_id'
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
# GET /users?posts.created_at=2020-01-01&posts.rel=>=
# GET /users?post_id.rel=is_null
# GET /users?post_id.rel=is_not_null
module Filterable
  extend ActiveSupport::Concern

  included do
    class_attribute :filter_fields, default: []
    class_attribute :mapped_filter_fields, default: []
  end

  class_methods do
    # @param keys [Array<Symbol,String,Hash>]
    def filterable_by(*keys, **mapped_keys)
      self.filter_fields = keys
      self.mapped_filter_fields = mapped_keys
    end
  end

  # @param scope [ActiveRecord::Relation]
  # @param filter_conditions [Array<Hash>]
  # @param filter_conditions[:field] [Symbol,String]
  # @param filter_conditions[:value] [String,Integer,Array<String,Integer>]
  # @param filter_conditions[:relation] [String]
  # @return [ActiveRecord::Relation]
  def filter(scope, filter_conditions: filter_conditions(*filter_fields, **mapped_filter_fields))
    Queries::Filter.call(scope, filter_conditions:)
  end

  # @param fields [Array<Symbol,String>]
  # @param mapped_fields [Array<Hash<Symbol,String>>]
  # @return [Array<Hash>]
  def filter_conditions(*fields, **mapped_fields)
    simple_filters = fields.presence || filter_fields
    mapped_filters = mapped_fields.to_a.presence || mapped_filter_fields

    (simple_filters + mapped_filters).filter_map do |filter_opt|
      field = filter_name(filter_opt)

      next if filter_value(filter_opt).blank? && %w[is_null is_not_null].exclude?(filter_rel_value(filter_opt))

      {
        field:,
        value: filter_value(filter_opt),
        relation: filter_rel_value(filter_opt) || (filter_value(filter_opt).is_a?(Array) ? 'in' : '=')
      }
    end
  end

  def filter_fields
    self.class.filter_fields
  end

  def mapped_filter_fields
    self.class.mapped_filter_fields
  end

  private

  def filter_name(filter)
    filter.is_a?(Array) ? filter.first : filter
  end

  def filter_mapped_name(filter)
    filter.is_a?(Array) ? filter.last : filter
  end

  def filter_value(filter)
    param_key = filter_mapped_name(filter)
    params[param_key]
  end

  def filter_rel_value(filter)
    param_key = filter_mapped_name(filter)
    params["#{param_key}.rel"]
  end
end
