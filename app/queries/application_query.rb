# frozen_string_literal: true

# This module adds the ability to sort scopes using the #sort method.
# Example usage:
# class User < ApplicationRecord
#   scope :confirmed_desc, ConfirmedDescQuery
#   scope :global_confirmed_desc, GlobalConfirmedDescQuery[self]
# end
#
# app/queries/global_confirmed_desc_query.rb
# class GlobalConfirmedDescQuery < ApplicationQuery
#   def resolve()
#     relation.where.not(confirmed_at: nil).order(created_at: :desc)
#   end
# end
#
# app/queries/user/confirmed_desc_query.rb
# class User
#   class ConfirmedDescQuery < ApplicationQuery
#     def resolve
#       relation.where.not(confirmed_at: nil).order(created_at: :desc)
#     end
#   end
# end
#
# class User
#   class ConfirmedBeforeDateQuery < ApplicationQuery
#     def resolve(date:)
#       relation.where.call(confirmed_at: ..date)
#     end
#   end
# end

#
# Example calls:
# User.confirmed_desc
# User.global_confirmed_desc
# User::ConfirmedDescQuery.new(User.all).call
# User::ConfirmedDescQuery.call(scope: User.all)
# User::ConfirmedBeforeDateQuery.new(User.all).call(date: Date.today)
# User::ConfirmedBeforeDateQuery.call(scope: User.all, date: Date.today)
#
class ApplicationQuery
  class << self
    attr_writer :query_model_name

    def query_model_name
      @query_model_name ||= name.sub(/::[^:]+$/, "")
    end

    def query_model
      query_model_name.safe_constantize
    end

    def [](model)
      Class.new(self).tap { _1.query_model_name = model.name }
    end

    def resolve(*, scope: nil, **)
      new(scope).resolve(*, **)
    end

    alias call resolve
  end

  private

  attr_reader :relation

  def initialize(scope)
    @relation = scope || self.class.query_model.all
  end
end
