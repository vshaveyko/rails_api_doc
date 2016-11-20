# coding: utf-8
# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_api_doc/version'

Gem::Specification.new do |spec|
  spec.name          = 'rails_api_documentation'
  spec.version       = RailsApiDoc::VERSION
  spec.authors       = ['vs']
  spec.email         = ['vshaveyko@gmail.com']

  spec.summary       = 'Nice API doc.'
  spec.description   = 'Document and view nice API docs.'
  spec.homepage      = 'https://github.com/vshaveyko/rails_api_doc'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
    # spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
    # raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  # end

  spec.files         = Dir['{app,config,db,lib}/**/*', 'README.md']

  spec.bindir        = 'exe'

  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_dependency 'actionpack'
  spec.add_dependency 'jquery-rails'
  spec.add_dependency 'sass-rails'
  spec.add_dependency 'coffee-rails'
  spec.add_dependency 'slim'
end
