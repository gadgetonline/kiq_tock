# frozen_string_literal: true

require 'byebug'
require 'kiqtock'

RSpec.configure do |config|
  config.define_derived_metadata do |meta|
    meta[:aggregate_failures] = true
  end

  config.disable_monkey_patching!
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.run_all_when_everything_filtered = true
end
