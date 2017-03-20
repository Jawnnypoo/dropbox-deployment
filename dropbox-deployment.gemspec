# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = 'dropbox-deployment'
  spec.version       = '0.0.0'
  spec.authors       = ["John Carlson"]
  spec.email         = ["jawnnypoo@gmail.com"]

  spec.summary       = "Deploy your CI artifacts to Dropbox"
  spec.homepage      = "https://github.com/Jawnnypoo/dropbox-deployment"
  spec.license       = "MIT"

  spec.files         = ["lib/dropbox-deployment.rb"]
  spec.executables   = ["dropbox-deployment"]
  spec.require_paths = ["lib"]

  spec.add_dependency "dropbox_api", "~> 0.1.5"
end
