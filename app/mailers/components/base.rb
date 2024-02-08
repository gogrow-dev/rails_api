# frozen_string_literal: true

module Components
  class Base
    include ActionView::Helpers::CaptureHelper

    attr_reader :view_context

    delegate :capture, :tag, :content_tag, to: :view_context
    delegate_missing_to :view_context

    class_attribute :slots, default: {}

    def self.slot(name)
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        # def header(&block)
        #   slots[:header] = block
        # end
        #
        # def header_content
        #   capture(&slots[:header]) if slots[:header]
        # end
        def #{name}(&block)
          slots[:#{name}] = block
        end

        def #{name}_content
          capture(&slots[:#{name}]) if slots[:#{name}]
        end
      RUBY
    end

    def slots
      self.class.slots
    end

    def template
      raise NotImplementedError
    end

    def content
      @content_block
    end

    def helpers
      return view_context if view_context.present?

      raise ArgumentError, 'helpers cannot be used during initialization, as it depends on the view context'
    end

    def render_in(view_context, &block)
      @view_context = view_context

      @content_block = capture { block.call(self) } if block_given?
      template
    end
  end
end
