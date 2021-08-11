# frozen_string_literal: true

module KiqTock
  module Validators
    class BaseValidator
      def self.valid?(value)
        new(value).valid?
      end

      def initialize(value)
        @value = value
      end

      def valid?
        raise UnimplementedError, "#{self.class.name} does not implement `valid?`"
      end

      private

      def raise_error
        klass           = self.class.name.split('::').last.gsub('Validator', '')
        exception_klass = "KiqTock::Error::Invalid#{klass}Error"

        exception_klass =
          if Object.const_defined?(exception_klass)
            Module.const_get(exception_klass)
          else
            KiqTock::Error
          end

        raise exception_klass, "'#{value}' is not a valid #{klass.downcase}"
      end

      attr_reader :value
    end
  end
end
