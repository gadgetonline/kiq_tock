# frozen_string_literal: true

require 'rails/generators'

module KiqTock
  class InstallGenerator < ::Rails::Generators::Base
    desc <<~DESC
      Description:
        Copy an empty periodic jobs schedule to the project
    DESC

    source_root File.expand_path('templates', __dir__)

    def install
      template 'periodic_jobs.yml', 'config/periodic_jobs.yml'
    end
  end
end
