# frozen_string_literal: true

module Components
  class Heading < Base
    LEVELS = [
      'font-size: 32px;',
      'font-size: 24px;',
      'font-size: 20px;',
      'font-size: 16px;',
      'font-size: 14px;',
      'font-size: 12px;'
    ].freeze
    def initialize(text = nil, level: 1, align: :center)
      super()
      @text = text
      @level = level
      @align = align

      raise ArgumentError, 'level must be 1, 2, 3, 4, 5 or 6' unless (1..6).include?(level)
      raise ArgumentError, 'align must be :left, :right or :center' unless %i[left right center].include?(align)
    end

    def text
      content.presence || @text
    end

    def style
      "text-align: #{@align}; font-weight: bold;" + LEVELS[@level - 1]
    end

    def template(&)
      tag.send("h#{@level}", text, style:)
    end
  end
end
