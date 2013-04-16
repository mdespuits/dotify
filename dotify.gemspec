# -*- encoding: utf-8 -*-
require File.expand_path('../lib/dotify/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "dotify"
  gem.version       = Dotify::VERSION
  gem.authors       = ["Matt Bridges"]
  gem.email         = ["mbridges.91@gmail.com"]
  gem.description   = %q{A tool for managing your dotfiles}
  gem.summary       = %q{A tool for managing your dotfiles}
  gem.homepage      = "https://github.com/mattdbridges/dotify"

  gem.files         = %w[README.md Rakefile LICENSE CHANGELOG.md dotify.gemspec]
  gem.files         += Dir['lib/**/*.rb']
  gem.files         += Dir['bin/*']
  gem.require_paths = %w[lib]
  gem.executables   = %w[dotify]
  gem.test_files    = Dir["spec/**/*"]

  gem.add_development_dependency 'rspec', '~> 2.13.0'
  # gem.add_development_dependency 'cucumber'
  # gem.add_development_dependency 'aruba'
end
