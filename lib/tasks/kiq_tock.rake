# frozen_string_literal: true

namespace :kiq_tock do
  desc 'Verify the syntax of a periodic jobs file'
  task :verify, [:filename] => :environment do |_task, args|
    KiqTock::Scheduler.register_jobs(
      jobs_file: args[:filename],
      scheduler: KiqTock::FakeSidekiq
    )
  end
end
