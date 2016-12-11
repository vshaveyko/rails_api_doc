# :nodoc:
class RailsApiDoc::Controller::Request::Factory

  class << self

    def repo
      attributes = RailsApiDoc::Controller::Request::Repository.new

      attributes = merge_attributes_from_model attributes

      attributes
    end

    def registered_controllers
      RailsApiDoc::Controller::Request::Repository.repo.keys
    end

    private

    #
    # do not mutate attributes
    #
    def merge_attributes_from_model(attributes)
      RailsApiDoc::Model::AttributeMerger.new(attributes).call(api_type: 'request')
    end

  end

end
