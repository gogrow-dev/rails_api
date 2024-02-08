# frozen_string_literal: true

module Components
  class Button < Base
    COLORS = {
      primary: 'background-color: #007bff; border: 1px solid #007bff;',
      secondary: 'background-color: #6c757d; border: 1px solid #6c757d;',
      danger: 'background-color: #dc3545; border: 1px solid #dc3545;'
    }.freeze
    SIZES = {
      sm: 'padding: 4px 8px; font-size: 12px;',
      md: 'padding: 6px 12px; font-size: 14px;',
      lg: 'padding: 8px 16px; font-size: 16px;'
    }.freeze

    def initialize(text = nil, url, color: :primary, size: :md)
      super()
      @text = text
      @url = url
      @color = color
      @size = size

      raise ArgumentError, 'color must be :primary, :secondary or :danger' unless %i[primary secondary danger].include?(color)
      raise ArgumentError, 'size must be :sm, :md or :lg' unless %i[sm md lg].include?(size)
    end

    def style
      base_style = 'color: #fff; border-color: #007bff; border-radius: 4px; text-decoration: none; display: inline-block;'
      base_style += COLORS[@color]
      base_style + SIZES[@size]
    end

    def text
      content.presence || @text
    end

    def template(&)
      tag.a(text, href: @url, style:)
    end
  end
end
