# frozen_string_literal: true

module Components
  module Layouts
    class Main < Base
      slot :header
      slot :main
      slot :footer

      def root_style
        'max-width: 600px; margin: 20px auto 0 auto; padding: 20px 30px; background-color: #fff; border-radius: 5px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);'
      end

      def template(&)
        tag.div(style: root_style) do
          content_tag(:div, style: 'vertical-align: middle;') do
            concat tag.header(header_content)
            concat tag.main(main_content)
            concat render Divider.new
            concat tag.footer(footer_content)
          end
        end
      end
    end
  end
end
