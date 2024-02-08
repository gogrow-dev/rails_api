# frozen_string_literal: true

module Components
  class Text < Base
    VARIANTS = {
      regular: 'color: #333;',
      muted: 'color: #666;',
      strong: 'font-weight: bold; color: #333;'
    }.freeze
    SIZES = {
      sm: 'font-size: 12px;',
      md: 'font-size: 14px;',
      lg: 'font-size: 16px;'
    }.freeze

    def initialize(text = nil, align: :left, variant: :regular, size: :md)
      super()
      @text = text
      @align = align
      @variant = variant
      @size = size

      raise ArgumentError, 'align must be :left, :right or :center' unless %i[left right center].include?(align)
      raise ArgumentError, 'variant must be :regular, :muted or :strong' unless %i[regular muted strong].include?(variant)
      raise ArgumentError, 'size must be :sm, :md or :lg' unless %i[sm md lg].include?(size)
    end

    def style
      base_style = "text-align: #{@align};"
      base_style += VARIANTS[@variant]
      base_style + SIZES[@size]
    end

    def text
      content.presence || @text
    end

    def template(&)
      tag.p(text, style:)
    end
  end
end
