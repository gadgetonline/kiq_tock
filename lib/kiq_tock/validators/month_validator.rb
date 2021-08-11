# frozen_string_literal: true

module KiqTock
  module Validators
    class MonthValidator < IntegerValidator
      MINIMUM = 0
      MAXIMUM = 11
    end
  end
end
