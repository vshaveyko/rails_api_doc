# :nodoc:
class RailsApiDoc::Controller::Request::Factory

  class << self

    def repo
      repo = RailsApiDoc::Controller::Request::Repository.new

      repo.repo = merge_attributes_from_model repo.repo

      repo
    end

    def registered_controllers
      RailsApiDoc::Controller::Request::Repository.repo.keys
    end

    private

    #
    # do not mutate attributes
    #
    def merge_attributes_from_model(attributes)
      RailsApiDoc::Model::AttributeMerger.new(attributes, 'request').call
    end

  end

end
