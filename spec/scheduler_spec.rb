# frozen_string_literal: true

module KiqTock
  RSpec.describe Scheduler do
    subject(:schedule) do
      described_class.new(jobs_file: file, scheduler: sidekiq).register_jobs
    end

    let(:directory) { File.join('spec', 'support', 'files') }
    let(:sidekiq)   { double }

    context 'with a periodic jobs file based on cron syntax' do
      let(:file) { File.join(directory, 'cron_schedule.yml') }

      it 'registers the job correctly' do
        allow(sidekiq).to receive(:register)
        schedule
        expect(sidekiq).to(
          have_received(:register)
          .with('0 * * * *', 'SampleJob', retries: 2)
        )
      end
    end

    context 'with a periodic jobs file with friendly syntax' do
      let(:file) { File.join(directory, 'friendly_schedule.yml') }

      it 'registers the job correctly' do
        allow(sidekiq).to receive(:register)
        schedule
        expect(sidekiq).to(have_received(:register))
      end
    end
  end
end
