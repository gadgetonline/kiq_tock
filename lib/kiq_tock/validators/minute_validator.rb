# frozen_string_literal: true

module KiqTock
  module Validators
    class MinuteValidator < IntegerValidator
      MINIMUM = 0
      MAXIMUM = 59
    end
  end
end
