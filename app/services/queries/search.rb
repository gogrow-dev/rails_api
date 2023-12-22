# frozen_string_literal: true

module Queries
  class Search < ApplicationService
    def initialize(scope, search_term:, model_search_scope: :search)
      super()
      @scope = scope
      @search_term = search_term
      @model_search_scope = model_search_scope
    end

    def call
      return scope if search_term.blank?

      validate_model_search_scope!

      scope.public_send(model_search_scope, search_term)
    end

    private

    attr_reader :scope, :search_term, :model_search_scope

    def validate_model_search_scope!
      return if scope.respond_to?(model_search_scope)

      raise ArgumentError, "#{scope.klass} does not respond to #{model_search_scope}"
    end
  end
end
