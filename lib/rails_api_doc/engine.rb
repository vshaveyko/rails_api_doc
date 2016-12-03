# author: Vadism Shaveiko <@vshaveyko>
# frozen_string_literal: true
require 'jquery-rails' # needed for require in javascript

require_relative 'railtie'

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

end
