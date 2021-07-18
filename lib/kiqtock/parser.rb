module Kiqtock
  class Parser
    SUBSTITUTIONS =
      {
        '0' => %w[sun sunday],
        '1' => %w[mon monday],
        '2' => %w[tue tues tuesday],
        '3' => %w[wed wednesday],
        '4' => %w[thu thur thursday],
        '5' => %w[fri friday],
        '6' => %w[sat saturday]
      }.freeze

    def self.explode(cron_expression)
      translate(cron_expression.to_s.gsub(/\s+/, '')).split(/,\s*/)
    end

    #
    # Substitute names for numbers, searching for longest matches first
    def self.translate(cron_expression)
      SUBSTITUTIONS.each_pair.inject(cron_expression) do |result, (day, names)|
        names.sort_by(&:length).reverse.inject(result) do |string, name|
          string.gsub(name, day)
        end
      end
    end
  end
end
