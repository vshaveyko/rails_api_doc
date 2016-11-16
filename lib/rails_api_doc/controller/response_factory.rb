# :nodoc:
class RailsApiDoc::Controller::Response

  # TODO: add more options later depending on app settings
  def self.repo
    ::RailsApiDoc::Controller::Response::Rabl.new(controllers)
  end

  def self.controllers
    RailsApiDoc::Controller::Parameter::Repository.registered_controllers
  end

end
