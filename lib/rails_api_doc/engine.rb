require 'action_controller'
require 'action_view'
require 'twitter-bootstrap-rails'
require 'jquery-rails'
require 'slim'

require_relative 'types'
require_relative 'controller'
require_relative 'controller/parameter'
require_relative 'controller/parameter/repository'

class RailsApiDoc::Engine < ::Rails::Engine
  isolate_namespace RailsApiDoc

  initializer "api_doc.assets.precompile" do |app|
  end

  ActionController::Base.class_eval do

     extend RailsApiDoc::Controller::Parameter

  end
end
