# -*- encoding: utf-8 -*-
require File.expand_path('../lib/dotify/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Matt Bridges"]
  gem.email         = ["mbridges.91@gmail.com"]
  gem.description   = %q{A CLI Tool for managing your dotfiles}
  gem.summary       = %q{A CLI Tool for managing your dotfiles}
  gem.homepage      = "https://github.com/mattdbridges/dotify"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "dotify"
  gem.require_paths = ["lib"]
  gem.version       = Dotify::VERSION
end
