# frozen_string_literal: true

require 'rails'
require 'yaml'

module KiqTock
  class Scheduler
    ANY               = '*'
    CRON_FIELDS       = %i[minutes hours days_of_month days_of_week months_of_year].freeze
    DEFAULT_JOBS_FILE = File.expand_path 'sidekiq/periodic_jobs.yml'

    def self.register_jobs(scheduler:, jobs_file: nil)
      new(scheduler: scheduler, jobs_file: jobs_file).register_jobs
    end

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
      return schedule if schedule.split.size == CRON_FIELDS.size

      raise SyntaxError, "Invalid cron schedule string: #{schedule}"
    end

    def interpret(field, value)
      return ANY if (value || '').to_s.size.zero?

      KiqTock::Parser.parse(field, value).join(',')
    end

    def jobs
      jobs_yaml.values.compact.map do |job|
        {
          class_name:  job[:job],
          retry_count: (job[:retries] || 0).to_i,
          schedule:    determine_schedule(job[:schedule] || {})
        }
      end
    end

    def jobs_yaml
      if defined?(Rails) && Rails.application
       return Rails.application.config_for(:periodic_jobs)
      end

      yaml = File.read(jobs_file || DEFAULT_JOBS_FILE)
      YAML.safe_load yaml, aliases: true, filename: jobs_file, symbolize_names: true
    end

    def schedule_from_hash(hash)
      hash
        .transform_keys(&:to_sym)
        .slice(*CRON_FIELDS)
        .map { |field, value| interpret(field, value) }
        .join(' ')
    end

    attr_reader :jobs_file, :scheduler
  end
end
