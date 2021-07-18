# frozen_string_literal: true

module Kiqtock
  module Validators
    class MonthValidator < IntegerValidator
      MINIMUM = 0
      MAXIMUM = 11
    end
  end
end
