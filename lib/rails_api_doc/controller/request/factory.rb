# :nodoc:
class RailsApiDoc::Controller::Request::Factory

  class << self

    def repo
      attributes = RailsApiDoc::Controller::Request::Repository

      attributes = merge_attributes_from_model attributes

      attributes
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
