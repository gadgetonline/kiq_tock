# frozen_string_literal: true

namespace :kiq_tock do
  desc 'Verify the syntax of a periodic jobs file'
  task :verify, [:filename] => :environment do |_task, args|
    sidekiq = KiqTock::FakeSidekiq
    byebug
    KiqTock::Scheduler.register_jobs scheduler: sidekiq, jobs_file: args[:filename]
  end
end
