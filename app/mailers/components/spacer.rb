# frozen_string_literal: true

module Components
  class Spacer < Base
    def style = 'height: 20px;'

    def template(&)
      tag.div(nil, style:)
    end
  end
end
