# frozen_string_literal: true

require_relative 'lib/kiq_tock/version'

Gem::Specification.new do |spec|
  spec.add_development_dependency 'brakeman', '~> 5.1'
  spec.add_development_dependency 'byebug', '~> 11.1'
  spec.add_development_dependency 'rubocop', '~> 1.19'
  spec.add_development_dependency 'rubocop-ordered_methods', '~> 0.9'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.4'
  spec.add_dependency 'cli-format', '~> 0.2'
  spec.add_dependency 'zeitwerk', '~> 2.4'

  spec.authors       = ['Martin Streicher']
  spec.bindir        = 'exe'
  spec.email         = ['martin.streicher@gadget.consulting']
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }

  spec.files =
    Dir.chdir(File.expand_path(__dir__)) do
      `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
    end

  spec.homepage      = 'https://github.com/gadgetonline/kiq_tock'
  spec.license       = 'MIT'

  spec.metadata['homepage_uri']    = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/gadgetonline/kiq_tock'
  spec.metadata['changelog_uri']   = 'https://github.com/gadgetonline/kiq_tock/CHANGELOG.md.'

  spec.name          = 'kiq_tock'
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.7'
  spec.summary       = 'Define peridic jobs in readable text and YAML'
  spec.version       = KiqTock::VERSION
end
