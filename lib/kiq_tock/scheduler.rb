# frozen_string_literal: true

require 'cli-format'
require 'rails'
require 'yaml'

module KiqTock
  class Scheduler
    ANY                = '*'
    CLI_ERROR_HEADERS  = %w[Description Job Error].freeze
    CLI_FORMAT_OPTIONS = { header: true, format: 'table' }.freeze
    CLI_JOB_HEADERS    = %w[Description Job Schedule].freeze
    CRON_FIELDS        = %i[minutes hours days_of_month days_of_week months_of_year].freeze
    DEFAULT_JOBS_FILE  = File.expand_path 'sidekiq/periodic_jobs.yml'
    EMPTY_SCHEDULE     = CRON_FIELDS.map { |key| [key, nil] }.to_h.freeze

    def self.register_jobs(scheduler:, jobs_file: nil)
      new(scheduler: scheduler, jobs_file: jobs_file).register_jobs
    end

    def initialize(scheduler:, jobs_file: nil)
      @errors    = []
      @jobs_file = jobs_file
      @presenter = CliFormat::Presenter.new CLI_FORMAT_OPTIONS
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

      summarize
    end

    private

    def determine_schedule(job)
      schedule = job[:schedule] || {}
      schedule = schedule_from_hash(schedule) if schedule.is_a?(Hash)
      return schedule if schedule.split.size == CRON_FIELDS.size

      report_or_raise_error KiqTock::Error::SyntaxError, "Invalid schedule '#{schedule}'", job
    end

    def interpret(field, value)
      return ANY if (value || '').to_s.size.zero?

      KiqTock::Parser.parse(field, value).join(',')
    end

    def jobs
      jobs_yaml.values.compact.each_with_object([]) do |job, list|
        job[:job].constantize
        retries  = (job[:retries] || 0).to_i
        schedule = determine_schedule job
        presenter.rows << [job[:description], job[:job], schedule]
      rescue NameError
        report_or_raise_error NameError, 'Unknown job class', job
      ensure
        list << { class_name: job[:job], retry_count: retries, schedule: schedule }
      end
    end

    def jobs_yaml
      return Rails.application.config_for(:periodic_jobs) if defined?(Rails) && Rails.application

      YAML.safe_load yaml_file, aliases: true, filename: jobs_file, symbolize_names: true
    end

    def report_or_raise_error(exception, message, job)
      error_message = message
      errors << [job[:description], job[:job], error_message]
      return if scheduler.respond_to?(:verify?)

      error_message = "#{error_message} in #{job[:description]}" if job[:description].present?
      raise exception, error_message
    end

    def schedule_from_hash(hash)
      hash
        .transform_keys(&:to_sym)
        .slice(*CRON_FIELDS)
        .reverse_merge(EMPTY_SCHEDULE)
        .map { |field, value| interpret(field, value) }
        .join(' ')
    end

    def summarize
      presenter.rows   = errors if errors.any?
      presenter.header = errors.any? ? CLI_ERROR_HEADERS : CLI_JOB_HEADERS
      presenter.show if presenter.rows.any?
    end

    def yaml_file
      File.read(jobs_file || DEFAULT_JOBS_FILE)
    end

    attr_reader :errors, :jobs_file, :presenter, :scheduler
  end
end
