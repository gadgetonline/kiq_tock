# frozen_string_literal: true

require_relative 'lib/kiqtock/version'

Gem::Specification.new do |spec|
  spec.add_development_dependency 'brakeman'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-ordered_methods'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_dependency 'zeitwerk'

  spec.authors       = ['Martin Streicher']
  spec.bindir        = 'exe'
  spec.email         = ['martin.streicher@gadget.consulting']
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end

  spec.homepage      = 'https://github.com/gadgetonline/kiqtock'
  spec.license       = 'MIT'

  spec.metadata['homepage_uri']    = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/gadgetonline/kiqtock'
  spec.metadata['changelog_uri']   = 'https://github.com/gadgetonline/kiqtock/CHANGELOG.md.'

  spec.name          = 'kiqtock'
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 3.0.0'
  spec.summary       = 'Define peridic jobs in readable text and YAML'
  spec.version       = Kiqtock::VERSION
end
