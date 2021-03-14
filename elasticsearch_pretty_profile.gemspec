require_relative "lib/elasticsearch_pretty_profile/version"

Gem::Specification.new do |spec|
  spec.name = "elasticsearch_pretty_profile"
  spec.version = ElasticsearchPrettyProfile::VERSION
  spec.authors = ["Pedro Chambino"]
  spec.email = ["pchambino@gmail.com"]

  spec.summary = "Pretty print an elasticsearch profile"
  spec.description = <<~TXT
    Iterate quickly from an irb/pry session. Use your own code to run Elasticsearch
    queries and pretty print the full profile or only the slow operations.

    Or when setting up Kibana is too troublesome.
  TXT
  spec.homepage = "https://github.com/pchambino/elasticsearch_pretty_profile"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.start_with? "spec" }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = Gem::Requirement.new(">= 2.7", "< 3.1")

  spec.add_development_dependency "pry", "~> 0.14"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.10"
  spec.add_development_dependency "standard", "~> 0.12"
end
