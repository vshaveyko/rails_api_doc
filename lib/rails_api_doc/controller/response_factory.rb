# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
class RailsApiDoc::Controller::Response

  class << self

    # TODO: add more options later depending on app settings
    def repo
      ::RailsApiDoc::Controller::Response::Rabl.new(controllers)
    end

    def controllers
      RailsApiDoc::Controller::Parameter::Repository.registered_controllers
    end

  end

end
