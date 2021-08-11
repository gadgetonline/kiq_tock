# frozen_string_literal: true

module KiqTock
  class Error
    class InvalidDayError    < StandardError; end

    class InvalidHourError   < StandardError; end

    class InvalidMinuteError < StandardError; end

    class InvalidMonthError  < StandardError; end
  end
end
