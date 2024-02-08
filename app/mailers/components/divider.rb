# frozen_string_literal: true

module Components
  class Divider < Base
    def style = 'border: none; border-top: 1px solid #ddd; margin: 20px 0;'

    def template(&)
      tag.hr(style:)
    end
  end
end
