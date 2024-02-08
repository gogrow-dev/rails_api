# frozen_string_literal: true

module Components
  module Code
    class Block < Base
      def initialize(code)
        super()
        @code = code
      end

      def style
        'display: block; padding: 10px; background-color: #f4f4f4; border-radius: 5px;'
      end

      def template(&)
        tag.pre do
          tag.code(@code, style:)
        end
      end
    end
  end
end
