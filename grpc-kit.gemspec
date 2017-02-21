# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'grpc/kit/version'

Gem::Specification.new do |spec|
  spec.name          = 'grpc-kit'
  spec.version       = GRPC::Kit::VERSION
  spec.authors       = ['Leonardo Saraiva']
  spec.email         = ['vyper@maneh.org']

  spec.summary       = 'GRPC toolkit for microservices'
  spec.description   = 'GRPC toolkit for microservices'
  spec.homepage      = 'http://github.com/b2beauty/grpc-kit'
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'google-cloud-pubsub', '~> 0.22.0'
  spec.add_dependency 'thor',                '~> 0.19.4'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake',    '~> 12.0'
  spec.add_development_dependency 'rspec',   '~> 3.0'
end
