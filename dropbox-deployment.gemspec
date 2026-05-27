# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = 'dropbox-deployment'
  spec.version       = '1.1.0'
  spec.authors       = ['John Carlson']
  spec.email         = ['jawnnypoo@gmail.com']

  spec.summary       = 'Deploy your CI artifacts to Dropbox'
  spec.homepage      = 'https://github.com/Jawnnypoo/dropbox-deployment'
  spec.license       = 'MIT'

  spec.files         = ['lib/dropbox-deployment.rb']
  spec.bindir        = 'bin'
  spec.require_paths << 'lib'
  spec.executables   << 'dropbox-deployment'

  spec.required_ruby_version = '>= 3.4'

  spec.metadata = {
    'source_code_uri' => 'https://github.com/Jawnnypoo/dropbox-deployment',
    'bug_tracker_uri' => 'https://github.com/Jawnnypoo/dropbox-deployment/issues',
    'rubygems_mfa_required' => 'true'
  }

  spec.add_dependency 'dotenv', '~> 3.2'
  spec.add_dependency 'dropbox_api', '~> 0.1', '>= 0.1.21'
end
