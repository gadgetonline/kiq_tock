# frozen_string_literal: true

module KiqTock
  class ScheduleInterpreter
    ANY            = '*'
    CRON_FIELDS    = %i[minutes hours days_of_month days_of_week months_of_year].freeze
    EMPTY_SCHEDULE = CRON_FIELDS.map { |key| [key, nil] }.to_h.freeze

    attr_reader :errors, :schedule

    def self.interpret(job)
      new(job).interpret
    end

    def initialize(job)
      @errors ||= []
      @job      = job
    end

    def failure?
      errors.any?
    end

    def interpret
      retries         = (job[:retries] || 0).to_i
      schedule_string = determine_schedule job

      begin
        job[:job].constantize
      rescue NameError => _e
        report_or_raise_error NameError, "Unknown job class '#{job[:job]}'", job
      end

      @schedule = { class_name: job[:job], retry_count: retries, schedule: schedule_string }

      self
    end

    def success?
      errors.empty?
    end

    private

    def determine_schedule(job)
      sched = job[:schedule] || {}
      sched = schedule_from_hash(sched) if sched.is_a?(Hash)
      return sched if sched.split.size == CRON_FIELDS.size

      report_or_raise_error KiqTock::Error::SyntaxError, "Invalid schedule '#{sched}'", job
    end

    def translate(field, value)
      return ANY if (value || '').to_s.size.zero?

      KiqTock::CronScheduleParser.parse(field, value).join(',')
    end

    def report_or_raise_error(exception, message, job)
      errors.push({ exception: exception, job: job, message: message })
    end

    def schedule_from_hash(hash)
      hash
        .transform_keys(&:to_sym)
        .slice(*CRON_FIELDS)
        .reverse_merge(EMPTY_SCHEDULE)
        .map { |field, value| translate(field, value) }
        .join(' ')
    end

    attr_reader :job
  end
end
