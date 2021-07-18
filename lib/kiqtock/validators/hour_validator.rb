# frozen_string_literal: true

module Kiqtock
  module Validators
    class HourValidator < IntegerValidator
      MINIMUM = 0
      MAXIMUM = 23
    end
  end
end