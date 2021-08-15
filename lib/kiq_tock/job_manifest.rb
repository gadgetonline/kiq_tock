# frozen_string_literal: true

require 'yaml'

module KiqTock
  class JobManifest
    DEFAULT_MANIFEST = File.expand_path 'sidekiq/periodic_jobs.yml'

    def self.jobs(manifest:)
      new(manifest: manifest).jobs
    end

    def initialize(manifest:)
      @manifest = manifest
    end

    def jobs
      jobs_yaml.values.compact
    end

    private

    def jobs_yaml
      return Rails.application.config_for(:periodic_jobs) if defined?(Rails) && Rails.application

      YAML.safe_load yaml_file, aliases: true, filename: manifest, symbolize_names: true
    end

    def yaml_file
      File.read(manifest || DEFAULT_MANIFEST)
    end

    attr_reader :manifest
  end
end
