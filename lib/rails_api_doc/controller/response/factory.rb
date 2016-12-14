# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
class RailsApiDoc::Controller::Response::Factory

  class << self

    # TODO: add more options later depending on app settings
    # TODO: rename to :load_repo
    def repo
      RailsApiDoc::Controller::Response::Repository.new(repository.repo)
    end

    def controllers
      RailsApiDoc::Controller::Request::Factory.registered_controllers
    end

    private

    def repository
      @repo ||= ::RailsApiDoc::Controller::Response::Rabl.new(controllers)
    end

  end

end
