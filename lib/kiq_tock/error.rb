# frozen_string_literal: true

module KiqTock
  class Error
    class InvalidDayError    < StandardError; end

    class InvalidHourError   < StandardError; end

    class InvalidMinuteError < StandardError; end

    class InvalidMonthError  < StandardError; end

    class SyntaxError < StandardError; end

    attr_reader :exception, :job, :message

    def initialize(job:, message:, exception: nil)
      @exception = exception
      @job       = job
      @message   = message
    end
  end
end
