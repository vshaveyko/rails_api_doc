# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
class RailsApiDoc::Controller::Request::Repository

  extend RailsApiDoc::Controller::Request::Headers
  extend RailsApiDoc::Controller::Repo

  def self.registered_controllers
    repo.keys
  end

end
