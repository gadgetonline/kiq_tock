# frozen_string_literal: true

module KiqTock
  module Validators
    class InclusionValidator
      VALID_VALUES = [].freeze

      def self.valid?(_value)
        self::VALID_VALUES.empty? || self::VALID_VALUES.include?(value)
      end
    end
  end
end
