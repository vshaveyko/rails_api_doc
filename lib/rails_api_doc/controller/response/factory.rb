# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
class RailsApiDoc::Controller::Response::Factory

  class << self

    # TODO: add more options later depending on app settings
    # TODO: rename to :load_repo
    def repo
      attributes = RailsApiDoc::Controller::Response::Repository.new(repository.repo)

      attributes = merge_attributes_from_model attributes

      attributes
    end

    def controllers
      RailsApiDoc::Controller::Request::Factory.registered_controllers
    end

    private

    def repository
      @repo ||= ::RailsApiDoc::Controller::Response::Rabl.new(controllers)
    end

    #
    # do not mutate attributes
    #
    def merge_attributes_from_model(attributes)
      RailsApiDoc::Model::AttributeMerger.new(attributes).call(api_type: 'response')
    end

  end

end
