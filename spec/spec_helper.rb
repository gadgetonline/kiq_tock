# frozen_string_literal: true

require 'byebug'
require 'kiq_tock'
require_relative 'support/classes/sample_job'

RSpec.configure do |config|
  Kernel.srand config.seed

  config.define_derived_metadata { |meta| meta[:aggregate_failures] = true }
  config.disable_monkey_patching!
  config.example_status_persistence_file_path = '.rspec_status'
  config.expect_with(:rspec) { |c| c.syntax = :expect }
  config.order = :random
  config.run_all_when_everything_filtered = true
end
