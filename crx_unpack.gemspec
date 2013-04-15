# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'crx_unpack/version'

Gem::Specification.new do |spec|
  spec.name          = "crx_unpack"
  spec.version       = CrxUnpack::VERSION
  spec.authors       = ["Kensuke Nagae"]
  spec.email         = ["kyanny@gmail.com"]
  spec.description   = %q{Unpack Chrome extension (crx) file}
  spec.summary       = %q{Unpack Chrome extension (crx) file}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.executables   = %w(crx_unpack)

  spec.add_dependency "rubyzip"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
