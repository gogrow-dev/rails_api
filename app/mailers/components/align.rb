# frozen_string_literal: true

module Components
  class Align < Base
    def initialize(align)
      super()
      @align = align

      raise ArgumentError, 'align must be :left, :right or :center' unless %i[left right center].include?(@align)
    end

    def style = "text-align: #{@align};"

    def template(&)
      tag.div(content, style:)
    end
  end
end
