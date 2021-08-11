# frozen_string_literal: true

require_relative 'kiq_tock/version'
require_relative 'kiq_tock/railtie' if defined?(Rails::Railtie)

require 'zeitwerk'

loader = Zeitwerk::Loader.for_gem
loader.setup
