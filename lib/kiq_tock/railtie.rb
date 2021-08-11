# frozen_string_literal: true

module KiqTock
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'tasks/kiq_tock.rake'
    end
  end
end
