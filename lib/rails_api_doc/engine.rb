require 'twitter-bootstrap-rails'
require 'jquery-rails'

module RailsApiDoc
  class Engine < ::Rails::Engine
    isolate_namespace RailsApiDoc

    # initializer "api_doc.assets.precompile" do |app|
      # app.config.assets.precompile += %w(resque_web/*.png)
    # end
  end
  module Plugins
    def self.plugins
      self.constants.map{ |m| self.const_get(m )}
    end
  end
end
