# frozen_string_literal: true

# Example usage:
#
# class UsersController < ApplicationController
#  include Pageable
#
#   def index
#     scope = paginate(User.all)
#     render json: scope, root: :users, meta: page_info
#   end
# end
#
# Example requests:
# GET /users?page=1&per_page=10
# GET /users?page=2&per_page=50
module Pageable
  extend ActiveSupport::Concern

  included do
    class_attribute :default_per_page, default: Queries::Paginate::DEFAULT_PER_PAGE
  end

  # @param scope [ActiveRecord::Relation]
  # @return [ActiveRecord::Relation]
  def paginate(scope)
    @page_info, paginated_scope = Queries::Paginate.call(scope, page:, per_page:)
    paginated_scope
  end

  # @return [String,nil]
  def page
    params[:page]
  end

  # @return [String,nil]
  def per_page
    params[:per_page].presence || self.class.default_per_page
  end

  # @return [Hash]
  def page_info
    raise ArgumentError, 'pagination was not performed' if @page_info.blank?

    @page_info
  end
end
