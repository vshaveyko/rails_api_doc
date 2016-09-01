require 'twitter-bootstrap-rails'
require 'jquery-rails'

module RailsApiDoc
  class Engine < ::Rails::Engine
    isolate_namespace RailsApiDoc

    initializer "api_doc.assets.precompile"
  end
end
