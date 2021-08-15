# frozen_string_literal: true

module KiqTock
  class CronScheduleParser
    DAY_OF_WEEK_SUBSTITUTIONS =
      {
        '0' => %w[sun sunday],
        '1' => %w[mon monday],
        '2' => %w[tue tues tuesday],
        '3' => %w[wed wednesday],
        '4' => %w[thu thur thursday],
        '5' => %w[fri friday],
        '6' => %w[sat saturday]
      }.freeze

    MONTH_OF_YEAR_SUBSTITUTIONS =
      {
        '0'  => %w[jan january],
        '1'  => %w[feb february],
        '2'  => %w[mar march],
        '3'  => %w[apr april],
        '4'  => %w[may],
        '5'  => %w[jun june],
        '6'  => %w[jul july],
        '7'  => %w[aug august],
        '8'  => %w[sep sept september],
        '9'  => %w[oct october],
        '10' => %w[nov november],
        '11' => %w[dec december]
      }.freeze

    def self.parse(field, cron_expression)
      expression = cron_expression.to_s.gsub(/\s+/, '')

      case field.to_sym
      when :days_of_week
        translate_days expression
      when :months_of_year
        translate_months expression
      else
        expression
      end.split(/,\s*/)
    end

    def self.translate(substitutions, cron_expression)
      substitutions.each_pair.inject(cron_expression) do |result, (number, names)|
        names.sort_by(&:length).reverse.inject(result) do |string, name|
          string.gsub(name, number)
        end
      end
    end

    #
    # Substitute names for numbers, searching for longest matches first
    def self.translate_days(cron_expression)
      translate DAY_OF_WEEK_SUBSTITUTIONS, cron_expression
    end

    #
    # Substitute names for numbers, searching for longest matches first
    def self.translate_months(cron_expression)
      translate MONTH_OF_YEAR_SUBSTITUTIONS, cron_expression
    end
  end
end
