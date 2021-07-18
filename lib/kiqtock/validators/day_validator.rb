# frozen_string_literal: true

module Kiqtock
  module Validators
    class DayValidator < IntegerValidator
      MINIMUM = 0
      MAXIMUM = 6
    end
  end
end
