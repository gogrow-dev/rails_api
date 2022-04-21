# frozen_string_literal: true

module Api
  module Concerns
    module Serializable
      extend ActiveSupport::Concern

      def render_serialized(resource, serializer_class: nil, serializer_namespace: nil, options: {}, status: :ok)
        render json: serialize(resource, serializer_class:, serializer_namespace:, options:),
               status:
      end

      def serialize(record, serializer_class: nil, serializer_namespace: nil, options: {})
        attributes = serializer_klass(record, serializer_class, serializer_namespace)
                     .new(record, options)
                     .serializable_hash
        attributes[:errors] = serialized_error(record) if record.errors.any?
        attributes.to_json
      end

      def generic_error(error_message)
        {
          errors: [{
            detail: error_message,
            source: { pointer: '' }
          }]
        }.to_json
      end

      private

      def serializer_klass(record, serializer_class, serializer_namespace)
        if serializer_class.nil?
          return [serializer_namespace,
                  "#{record.class}Serializer"].compact.join('::').constantize
        end

        serializer_class.constantize
      end

      def pointer_for(key)
        "data/attributes/#{key}"
      end

      def serialized_error(record)
        record.errors.to_hash.flat_map do |attribute, message_arr|
          message_arr.map do |message|
            build_error_hsh(attribute, message)
          end
        end
      end

      def build_error_hsh(attribute, message)
        {
          detail: "#{attribute.to_s.humanize} #{message}",
          source: {
            parameter: attribute,
            pointer: pointer_for(attribute)
          }
        }
      end
    end
  end
end
