# frozen_string_literal: true

module Components
  module Code
    class Inline < Base
      def initialize(code)
        super()
        @code = code
      end

      def style
        'padding: 2px 5px; background-color: #f4f4f4; border-radius: 5px;'
      end

      def template(&)
        tag.code(@code, style:)
      end
    end
  end
end
