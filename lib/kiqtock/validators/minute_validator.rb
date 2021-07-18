# frozen_string_literal: true

module Kiqtock
  module Validators
    class MinuteValidator < IntegerValidator
      MINIMUM = 0
      MAXIMUM = 59
    end
  end
end
