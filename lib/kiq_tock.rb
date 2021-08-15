# frozen_string_literal: true

require_relative 'kiq_tock/version'
require_relative 'kiq_tock/railtie' if defined?(Rails::Railtie)
require 'zeitwerk'

loader = Zeitwerk::Loader.for_gem
loader.setup

module KiqTock
  CLI_ERROR_HEADERS  = %w[Description Job Error].freeze
  CLI_FORMAT_OPTIONS = { header: true, format: 'table' }.freeze
  CLI_JOB_HEADERS    = %w[Description Job Schedule].freeze
end
