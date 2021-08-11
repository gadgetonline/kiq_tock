# frozen_string_literal: true

module KiqTock
  module Validators
    class IntegerValidator < BaseValidator
      MINIMUM = -Float::INFINITY
      MAXIMUM = Float::INFINITY

      def valid?
        value.to_s.match?(/\A[+-]?((0)|([1-9]\d*))\z/) || raise_error

        (self.class::MINIMUM..self.class::MAXIMUM).include?(value)
      end
    end
  end
end
