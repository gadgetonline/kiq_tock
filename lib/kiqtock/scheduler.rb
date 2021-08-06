# frozen_string_literal: true

require 'yaml'

module Kiqtock
  class Scheduler
    CRON_FIELDS       = %i[minutes hours days_of_month months days_of_week].freeze
    DEFAULT_JOBS_FILE = File.expand_path 'sidekiq/periodic_jobs.yml'

    def initialize(scheduler:, jobs_file: nil)
      @jobs_file = jobs_file
      @scheduler = scheduler
    end

    def register_jobs
      jobs.each do |job|
        scheduler.register(
          job[:schedule],
          job[:class_name],
          retries: job[:retry_count]
        )
      end
    end

    private

    def determine_schedule(schedule)
      schedule = schedule_from_hash(schedule) if schedule.is_a?(Hash)
      raise(SyntaxError, 'invalid cron schedule string') if schedule.split.size != CRON_FIELDS.size

      schedule
    end

    def interpret(field, value)
      return ANY unless value.presence?


    end

    def jobs
      jobs_yaml.values.compact.map do |job|
        {
          class_name: job[:job],
          retry_count: (job[:retries] || 0).to_i,
          schedule: determine_schedule(job[:schedule] || {})
        }
      end
    end

    def jobs_yaml
      return Rails.application.config_for(:periodic_jobs) if defined?(Rails)

      yaml = File.read(jobs_file || DEFAULT_JOBS_FILE)
      YAML.safe_load yaml, aliases: true, filename: jobs_file, symbolize_names: true
    end

    def schedule_from_hash(hash)
      hash
        .transform_keys(&:to_sym)
        .values_at(*CRON_FIELDS)
        .map { |field| field.presence || '*' }
        .join(' ')
    end

    attr_reader :jobs_file, :scheduler
  end
end
