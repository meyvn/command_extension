# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'command_extension/version'

Gem::Specification.new do |spec|
  spec.name          = 'command_extension'
  spec.version       = CommandExtension::VERSION
  spec.authors       = ['Alexander Fedulin', 'Alexander Strelnikov']
  spec.email         = ['aristat37@gmail.com']

  spec.summary       = 'Command pattern with after commit logic to avoid AR model callbacks'
  spec.description   = 'Command pattern with after commit logic to avoid AR model callbacks'
  spec.homepage      = 'https://github.com/meyvn/command_extension'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.10'
  spec.add_development_dependency 'singleton', '~> 0.1'
end
