require_relative 'lib/pi_bender/version'

Gem::Specification.new do |spec|
  spec.name          = "pi_bender"
  spec.version       = PiBender::VERSION
  spec.authors       = ["Jonan Scheffler"]
  spec.email         = ["jonanscheffler@gmail.com"]

  spec.summary       = %q{Configuration CLI to prepare Raspberry Pis for Kubernetes}
  spec.homepage      = "https://github.com/thejonanshow/pi_bender"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/thejonanshow/pi_bender"
  spec.metadata["changelog_uri"] = "https://github.com/thejonanshow/pi_bender/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "pry-byebug"
  spec.add_runtime_dependency "unix-crypt", "~> 1.3.0"
  spec.add_runtime_dependency "faraday", "~> 1.0.1"
end
