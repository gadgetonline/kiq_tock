# frozen_string_literal: true

require 'cli-format'
require 'rails'

module KiqTock
  class Scheduler
    def self.register_jobs(scheduler:, jobs_file: nil)
      new(scheduler: scheduler, jobs_file: jobs_file).register_jobs
    end

    def initialize(scheduler:, jobs_file: nil)
      @list_of_jobs = JobManifest.jobs(manifest: jobs_file)
      @scheduler    = scheduler
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

    def errors
      @errors ||= []
    end

    def jobs
      list_of_jobs.each_with_object([]) do |job, list|
        result = ScheduleInterpreter.interpret job
        next unless result.success?

        list.push result.schedule
        presenter.rows << [job[:description], job[:job], result.schedule]
      end
    end

    #   presenter.rows << [job[:description], job[:job], schedule]
    # rescue NameError => _e
    #   report_or_raise_error NameError, "Unknown job class '#{job[:job]}'", job
    # ensure
    #   list << { class_name: job[:job], retry_count: retries, schedule: schedule }
    # end

    def presenter
      @presenter ||= CliFormat::Presenter.new(CLI_FORMAT_OPTIONS)
    end

    def report_or_raise_error(exception, message, job)
      error_message = message
      errors << [job[:description], job[:job], error_message]
      return if verify?

      error_message = "#{error_message} in #{job[:description]}" if job[:description].present?
      raise exception, error_message
    end

    def summarize
      presenter.rows   = errors if errors.any?
      presenter.header = errors.any? ? CLI_ERROR_HEADERS : CLI_JOB_HEADERS
      presenter.show if presenter.rows.any?
    end

    def verify?
      scheduler.respond_to?(:verify?) && scheduler.verify?
    end

    attr_reader :list_of_jobs, :scheduler
  end
end
