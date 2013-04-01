require File.expand_path('../lib/rsid/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Lars Haugseth"]
  gem.email         = ["rsid@larshaugseth.com"]
  gem.description   = %q{SID file format support}
  gem.summary       = %q{SID file format support}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "rsid"
  gem.require_paths = ["lib"]
  gem.version       = RSID::VERSION

  gem.add_development_dependency "pry", "~> 0.9.12"
end
