# frozen_string_literal: true

module Queries
  class Filter < ApplicationService
    RELATIONS = %w[= != > >= < <= between in starts_with ends_with contains is_null is_not_null].freeze

    def initialize(scope, filter_conditions:)
      super()
      @scope = scope
      @filter_conditions = filter_conditions
    end

    def call
      filter_conditions.reduce(scope) do |scope, filter_condition|
        relation = filter_condition[:relation].to_s
        field = filter_condition[:field]
        value = filter_condition[:value]

        validate_relation!(relation)
        filtered_scope(scope, relation, field, value)
      end
    end

    private

    attr_reader :scope, :filter_conditions

    def validate_relation!(relation)
      return if RELATIONS.include?(relation)

      raise ArgumentError, "relation must be one of: #{RELATIONS.join(', ')}"
    end

    def filtered_scope(scope, relation, field, value)
      case relation
      when '=', 'in'
        scope.where(field => value)
      when '!='
        scope.where.not(field => value)
      when 'between'
        scope.where("#{field} BETWEEN ? AND ?", value.first, value.last)
      when 'starts_with'
        scope.where("#{field} LIKE ?", "#{value}%")
      when 'ends_with'
        scope.where("#{field} LIKE ?", "%#{value}")
      when 'contains'
        scope.where("#{field} LIKE ?", "%#{value}%")
      when 'is_null'
        scope.where(field => nil)
      when 'is_not_null'
        scope.where.not(field => nil)
      else # '>', '>=', '<', '<='
        scope.where("#{field} #{relation} ?", value)
      end
    end
  end
end
