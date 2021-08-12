# frozen_string_literal: true

require_relative 'kiq_tock/version'
require_relative 'kiq_tock/railtie' if defined?(Rails::Railtie)
require 'zeitwerk'

loader = Zeitwerk::Loader.for_gem
loader.setup

module KiqTock
  ANY                = '*'
  CLI_ERROR_HEADERS  = %w[Description Job Error].freeze
  CLI_FORMAT_OPTIONS = { header: true, format: 'table' }.freeze
  CLI_JOB_HEADERS    = %w[Description Job Schedule].freeze
  CRON_FIELDS        = %i[minutes hours days_of_month days_of_week months_of_year].freeze
  DEFAULT_JOBS_FILE  = File.expand_path 'sidekiq/periodic_jobs.yml'
  EMPTY_SCHEDULE     = CRON_FIELDS.map { |key| [key, nil] }.to_h.freeze
end
