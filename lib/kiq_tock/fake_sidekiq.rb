# frozen_string_literal: true

module KiqTock
  class FakeSidekiq
    def self.register(*args); end

    def self.verify?
      true
    end
  end
end
