# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
class RailsApiDoc::Controller::Response::Factory

  class << self

    # TODO: add more options later depending on app settings
    def repo
      attributes = ::RailsApiDoc::Controller::Response::Rabl.new(controllers)

      attributes = merge_attributes_from_model attributes

      attributes
    end

    def controllers
      RailsApiDoc::Controller::Request::Repository.registered_controllers
    end

    private

    #
    # do not mutate attributes
    #
    def merge_attributes_from_model(attributes)
      RailsApiDoc::Model::AttributeMerger.new(attributes).call(api_type: 'response')
    end

  end

end
