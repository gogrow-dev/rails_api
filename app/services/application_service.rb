# frozen_string_literal: true

class ApplicationService
  def self.call(...)
    new(...).call
  end

  def call
    raise NotImplementedError
  end

  # This method is used to create an Async class that inherits from ApplicationJob
  # and calls the service asynchronously.
  # Example:
  # class SomeService < ApplicationService
  #   enable_async!
  #
  #   def call(...)
  #     ...
  #   end
  # end
  #
  # SomeService.call_later(...)
  # SomeService::Async.perform_later(...)
  def self.enable_async!
    class_eval <<-RUBY, __FILE__, __LINE__ + 1
      # class ApplicationService
      #   class Async < ApplicationJob
      #     queue_as :default
      #
      #     def perform(...)
      #       ApplicationService.call(...)
      #     end
      #   end
      #
      #  def self.call_later(...)
      #    Async.perform_later(...)
      #  end
      # end
      class Async < ApplicationJob
        queue_as :default
        def perform(...)
          #{name}.call(...)
        end
      end

      def self.call_later(...)
        Async.perform_later(...)
      end
    RUBY
  end
end
