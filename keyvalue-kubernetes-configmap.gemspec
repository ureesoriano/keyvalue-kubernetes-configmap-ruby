require_relative 'lib/keyvalue/kubernetes/configmap/version'

Gem::Specification.new do |spec|
  spec.name          = "keyvalue-kubernetes-configmap"
  spec.version       = KeyValue::Kubernetes::Configmap::VERSION
  spec.authors       = ["Oriol Soriano"]
  spec.email         = ["oriolsoriano@gmail.com"]

  spec.summary       = %q{key-value store backed by kubernetes configmaps}
  spec.homepage      = "https://github.com/ureesoriano/keyvalue-kubernetes-configmap-ruby"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  #spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir["lib/**/*.rb"]
  spec.require_paths = ["lib"]

end