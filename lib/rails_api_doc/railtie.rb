# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
module RailsApiDoc
  class Railtie < Rails::Railtie

    initializer 'api_doc.controller_additions' do
      ActiveSupport.on_load :action_controller do
        include RailsApiDoc::Controller::ResourceParams::DSL

        extend RailsApiDoc::Controller::Request::DSL

        include RailsApiDoc::Params::DSL
      end
    end

  end
end
