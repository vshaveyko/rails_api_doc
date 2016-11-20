# author: Vadism Shaveiko <@vshaveyko>
# frozen_string_literal: true
require 'action_controller'
require 'action_view'
require 'jquery-rails'
require 'slim'

require_relative 'types'
require_relative 'controller'
require_relative 'controller/strong_params'
require_relative 'controller/attribute_parser'
require_relative 'controller/parameter'
require_relative 'controller/parameter/repository'
require_relative 'controller/parameter/repository/param'

require_relative 'controller/response_factory'

# add rabl support
begin
  require 'rabl'
  require_relative 'controller/response/rabl'
  require_relative 'controller/response/rabl_compiler'
  RailsApiDoc::Controller::Response::Rabl.renderer = Rabl::Renderer
rescue LoadError
end

class RailsApiDoc::Engine < ::Rails::Engine

  isolate_namespace RailsApiDoc

  initializer 'rails_api_doc.assets.precompile' do |app|
    app.config.assets.precompile += %w(application.css application.js api_doc.js rails_api_doc/api_doc.js)
  end

  ActionController::Base.class_eval do
    include RailsApiDoc::Controller::StrongParams
    extend RailsApiDoc::Controller::Parameter
  end

end
