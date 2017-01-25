# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
class RailsApiDoc::Params

  module ParamStorage
    def param_storage
      RailsApiDoc::Controller::Request::Repository[self]
    end

    private

    def responding_ctrl; end
  end

  extend ParamStorage
  include RailsApiDoc::Controller::ResourceParams::DSL
  extend RailsApiDoc::Controller::Request::DSL

end
