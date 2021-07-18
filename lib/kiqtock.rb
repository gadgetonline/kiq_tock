# frozen_string_literal: true

require_relative 'kiqtock/version'
require 'zeitwerk'

loader = Zeitwerk::Loader.for_gem
loader.setup

module Kiqtock
  class Error       < StandardError; end
  class InvalidDayError    < Error; end
  class InvalidHourError   < Error; end
  class InvalidMinuteError < Error; end
  class InvalidMonthError  < Error; end
end
