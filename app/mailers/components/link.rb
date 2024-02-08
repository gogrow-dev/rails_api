# frozen_string_literal: true

module Components
  class Link < Base
    VARIANTS = {
      regular: 'font-size: 14px; color: #3498db;',
      strong: 'font-size: 16px; font-weight: bold; color: #3498db;',
      muted: 'font-size: 14px; color: #666;'
    }.freeze

    def initialize(text = nil, url, variant: :regular)
      super()
      @text = text
      @url = url
      @variant = variant
    end

    def style
      VARIANTS[@variant]
    end

    def text
      content.presence || @text
    end

    def template(&)
      tag.a(text, href: @url, style:)
    end
  end
end
