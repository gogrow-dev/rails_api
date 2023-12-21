# frozen_string_literal: true

module Queries
  class Paginate < ApplicationService
    include Pagy::Backend

    MAX_PER_PAGE = 100
    DEFAULT_PER_PAGE = 10

    def initialize(scope, page: nil, per_page: nil)
      super()
      @scope = scope
      @page = page
      @per_page = per_page
    end

    def call
      metadata, paginated_scope = pagy_arel(scope, { items: per_page, page: })

      [paginated_scope, {
        page: metadata.page,
        per_page:,
        total_pages: metadata.pages,
        total_count: metadata.count,
        next_page: metadata.next,
        prev_page: metadata.prev
      }]
    end

    private

    attr_reader :scope

    def page
      @page.present? ? @page.to_i : 1
    end

    def per_page
      @per_page.present? ? [@per_page.to_i, MAX_PER_PAGE].min : DEFAULT_PER_PAGE
    end
  end
end
