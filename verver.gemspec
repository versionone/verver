# -*- encoding: utf-8 -*-
require File.expand_path('../lib/verver/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["David Laribee", "Steven Harman"]
  gem.email         = ["david.laribee@versionone.com", "steveharman@gmail.com"]
  gem.description   = %q{Automating our build environments should be easier.}
  gem.summary       = %q{Simple abstractions and Rake tasks for installing & managing VersionOne.}
  gem.homepage      = "http://github.com/versionone/verver"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "verver"
  gem.require_paths = ["lib"]
  gem.version       = Verver::VERSION

  gem.add_runtime_dependency "rake", "~> 0.9.2"
  gem.add_runtime_dependency "nokogiri", "~> 1.5.0"
  gem.add_runtime_dependency "rest-client", "~> 1.6.7"

  gem.add_development_dependency "rspec", "~> 2.8.0"
  gem.add_development_dependency "ci_reporter", "~> 1.6.9"

end
